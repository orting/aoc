df = read.table('inputs/1.txt')
rotations = as.integer(gsub('L', '-', gsub('R', '', df$V1)))
n = 50
password = 0
for (rotation in rotations) {
    m = 0
    s = sign(rotation)
    for (i in seq(abs(rotation))) {
        n = (n + s) %% 100
        if (n == 0) {
            password = password + 1
        }
    }
}
cat(paste0(password, "\n"))

n = 50
password = 0
for (rotation in rotations) {
    new_n = n + rotation
    if (new_n < 1 || new_n > 99) {
        crossings = abs(new_n %/% 100)
        if (new_n == 0) {
            crossings = crossings + 1
        }
        if (new_n < 0) {
            if (n == 0) {
                crossings = crossings - 1
            }
            if (new_n %% 100 == 0) {
                crossings = crossings + 1
            }
        }
        password = password + crossings
    }
    n = new_n %% 100
}
cat(paste0(password, "\n"))
