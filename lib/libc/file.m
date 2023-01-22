- (NSNumber *) hourglassSum:(NSArray *)arr {
    // Write your code here
    int max = -100;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            int sum = 0;
            sum += [arr[i][j] intValue];
            sum += [arr[i][j+1] intValue];
            sum += [arr[i][j+2] intValue];
            sum += [arr[i+1][j+1] intValue];
            sum += [arr[i+2][j] intValue];
            sum += [arr[i+2][j+1] intValue];
            sum += [arr[i+2][j+2] intValue];
            if (sum > max) {
                max = sum;
            }
        }
    }
    return @(max);
    
}