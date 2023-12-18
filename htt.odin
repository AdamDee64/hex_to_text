package hex_to_text

import "core:os"
import "core:fmt"
import "core:strings"

hex_to_byte :: proc(text : ^[]u8, i : int) -> u8 {
    output : u8
    for x in 0..=1{
        a : u8
        switch text[i + x] {
            case 48..=57:
            a = text[i + x] - 48
            case 65..=70:
            a = text[i + x] - 55
            case 97..=102:
            a = text[i + x] - 87
        }
        if x == 0 {
            output += a * 16
        } else {
            output += a
        }
    }
    return output
}


main :: proc() {
    if len(os.args) > 1 {
        input, open_err := os.open(os.args[1])
        text, read_success := os.read_entire_file_from_handle(input)

        if !read_success {
            fmt.print("Could not find filename", os.args[1], "\n")
        }

        size := len(text)
        str_byte_b : [dynamic]u8
        str_b : string
        str_arr : [dynamic]string

        i := 0

        for i < size {
            jump : int
            v := int(text[i])
            
            switch v {
                case 48..=57:
                b := hex_to_byte(&text, i)
                append(&str_byte_b, b)
                i += 2

                case 10:
                str_b = strings.string_from_ptr(&str_byte_b[0], len(str_byte_b))
                append(&str_arr, strings.clone(str_b))
                clear(&str_byte_b)
                i += 1

                case:
                i += 1
            }
        }
        if len(str_byte_b) != 0{ // handle last line if text file doesn't contain a new line at end
            str_b = strings.string_from_ptr(&str_byte_b[0], len(str_byte_b))
            append(&str_arr, strings.clone(str_b))
            clear(&str_byte_b)
        }
        
        for i in 0..<len(str_arr) {
            fmt.print(str_arr[i], "\n")
        }

    } else {
        fmt.print("No file found. exiting.")
    }

}