#!/bin/bash

# prefixed with smu so it does not clash
readonly smu_base16_theme="tomorrow-night"
readonly smu_postscript_font="FuraCodeNerdFontComplete-Retina"

readonly sublime_directory="${HOME}/Library/Application Support/Sublime Text 3"
readonly sublime_settings="${sublime_directory}/Packages/User/Preferences.sublime-settings"
readonly sublime_package_settings="${sublime_directory}/Packages/User/Package Control.sublime-settings"

readonly spacevim_settings="${HOME}/.SpaceVim.d/init.toml"

readonly iterm2_settings="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"

readonly base16_idea_download="https://github.com/adilosa/base16-jetbrains/tarball/master"
readonly base16_manager_templates=("chriskempson/base16-shell" "nicodebo/base16-fzf" "chriskempson/base16-vim")

stdin_to_file() {
    local -r file="${1}"

    echo "$(</dev/stdin)" > "${file}"
}

base16_install_template() {
    local -r installed_templates="${1}"
    local -r template="${2}"

    if [[ ! "${installed_templates}" =~ "${template}" ]]; then
        base16-manager install "${template}"
    fi
}

echo "------------------------------"
echo "Running themes module"
echo "------------------------------"
echo ""

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

echo "------------------------------"
echo "Theming shell, vim and fzf"

readonly templates=$(base16-manager list)

for template in "${base16_manager_templates[@]}"
do
    base16_install_template "${templates}" "${template}"
done

eval "$(${HOME}/.base16-manager/chriskempson/base16-shell/profile_helper.sh)"

base16-manager set "${smu_base16_theme}"

if [[ -e "${sublime_package_settings}" ]]; then
    echo "------------------------------"
    echo "Theming Sublime"

    jq -e '.installed_packages |= (. + ["Base16 Color Schemes", "Theme - Spacegray"] | unique)' \
          "${sublime_package_settings}" | stdin_to_file "${sublime_package_settings}"

    sublime_filter='.theme = "Spacegray.sublime-theme"
                    | .color_scheme = "Packages/Base16 Color Schemes/Themes/%s.tmTheme"
                    | .font_face = "%s"'
    sublime_filter=$(printf "${sublime_filter}" "${BASE16_THEME}" "${smu_postscript_font}")

    jq -e "${sublime_filter}" "${sublime_settings}" | stdin_to_file "${sublime_settings}"
fi

if [[ -e "${iterm2_settings}" ]]; then
    echo "------------------------------"
    echo "Theming iterm2"

    /usr/libexec/PlistBuddy -c "Delete:'New Bookmarks':0:'Normal Font'" \
                            -c "Add:'New Bookmarks':0:'Normal Font' string '${smu_postscript_font} 11'" \
                            -c "Delete:'New Bookmarks':0:'ASCII Anti Aliased'" \
                            -c "Add:'New Bookmarks':0:'ASCII Anti Aliased' bool true" \
                            -c "Delete:'New Bookmarks':0:'ASCII Ligatures'" \
                            -c "Add:'New Bookmarks':0:'ASCII Ligatures' bool true" \
                            -c "Delete:'New Bookmarks':0:'Use Non-ASCII Font'" \
                            -c "Add:'New Bookmarks':0:'Use Non-ASCII Font' bool true" \
                            -c "Delete:'New Bookmarks':0:'Non Ascii Font'" \
                            -c "Add:'New Bookmarks':0:'Non Ascii Font' string '${smu_postscript_font} 11'" \
                            -c "Delete:'New Bookmarks':0:'Non-ASCII Anti Aliased'" \
                            -c "Add:'New Bookmarks':0:'Non-ASCII Anti Aliased' bool true" \
                            -c "Delete:'New Bookmarks':0:'Non-ASCII Ligatures'" \
                            -c "Add:'New Bookmarks':0:'Non-ASCII Ligatures' bool true" \
                            "${iterm2_settings}"
fi

if [[ -e "${spacevim_settings}" ]]; then
    echo "------------------------------"
    echo "Theming SpaceVim"

    spacevim_filter='.options.custom_plugins |= (. + [["chriskempson/base16-vim"]] | unique)
                     | .options.colorscheme = "$BASE16_THEME"
                     | .options.guifont = "%s 12"'
    spacevim_filter=$(printf "${spacevim_filter}" "${smu_postscript_font}")

    # the json2toml -o argument results in incomplete toml files
    # i am to lazy to find out why exactly and therefor rely on stdin_to_file
    toml2json -i "${spacevim_settings}" | jq "${spacevim_filter}" | json2toml | stdin_to_file "${spacevim_settings}"
fi

if [[ -d "/Applications/IntelliJ IDEA.app" ]]; then
    echo "------------------------------"
    echo "Theming IntelliJ IDEA"

    readonly intellij_version=$(/usr/libexec/PlistBuddy -c "Print:JVMOptions:Properties:idea.paths.selector" "/Applications/IntelliJ IDEA.app/Contents/Info.plist")
    readonly intellij_preferences="${HOME}/Library/Preferences/${intellij_version}"
    readonly intellij_colors="${intellij_preferences}/colors"
    readonly intellij_color_options="${intellij_preferences}/options/colors.scheme.xml"
    readonly intellij_icls="${intellij_colors}/${BASE16_THEME}.icls"

    curl -#L ${base16_idea_download} | tar -x -C "${intellij_colors}" --strip-components=2 */colors/*.icls

    # unfortunately display and file name differ, intellij uses the display name
    readonly intellij_theme_name=$(xmlstarlet sel -t -v "/scheme/@name" "${intellij_icls}")

    # assume the scheme node is always there, thus creating it is not required
    xmlstarlet ed -L -u "//global_color_scheme/@name" -v "${intellij_theme_name}" "${intellij_color_options}"

    # assume the ligatures node does not exist, therefore create it
    xmlstarlet ed -L -d "//option[@name='EDITOR_LIGATURES']" \
                     -s "/scheme" -t "elem" -n "option" \
                     -i "//option[not(@name)]" -t "attr" -n "name" -v "EDITOR_LIGATURES" \
                     -i "//option[@name='EDITOR_LIGATURES']" -t "attr" -n "value" -v "true" \
                     "${intellij_icls}"

    # assume all base16 fonts have the font node in place, thus creating it is not required
     xmlstarlet ed -L -u "(//option[@name='EDITOR_FONT_NAME'])[1]/@value" -v "${smu_postscript_font}" "${intellij_icls}"
fi
