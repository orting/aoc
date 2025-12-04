df = read.table('inputs/1.txt')
rotations = as.integer(gsub('L', '-', gsub('R', '', df$V1)))
password = sum(cumsum(c(50, rotations)) %% 100 == 0)
cat(paste0(password, "\n"))
