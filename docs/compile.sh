#!/bin/bash
cd "$(dirname "$0")"
source_images=src/*.png
mkdir -p img
for source_img in $source_images; do
    dest_img=img/$(basename ${source_img%.png}.jpg)
    case "$(basename "$dest_img")" in

        paperwork-map.jpg)
            convert "$source_img" -crop 1080x720+50+190 -scale '50%x50%' -density 72x72 -quality 95 "$dest_img"
            ;;

        home-screen-annotated.jpg)
            convert "$source_img" -scale '50%x50%' -density 72x72 -quality 95 "$dest_img"
            ;;

        *)
            convert "$source_img" -crop 720x1010+150+32 -scale '50%x50%' -density 72x72 -quality 95 "$dest_img"
            ;;
    esac
done
(
    echo '<style>' 
    cat src/style.css
    echo '</style>'
    pandoc -f markdown -t html guide.markdown
) > index.html
