param (
    [int]$n = $null
)

function Get-FibonacciNumber {
    param (
        [int]$num
    )
    $a = 0
    $b = 1
    
    for ($i = 0; $i -lt $num; $i++) {
        $temp = $a
        $a = $b
        $b = $temp + $b
    }
    
    return $a
}

function Generate-FibonacciSequence {
    $num1 = 0
    $num2 = 1

    while ($true) {
        Write-Output $num1
        $sum = $num1 + $num2
        $num1 = $num2
        $num2 = $sum

        # Pause for half a second to make the output readable
        Start-Sleep -Milliseconds 500
    }
}

if ($PSBoundParameters.ContainsKey('n')) {
    $fibNumber = Get-FibonacciNumber -num $n
    Write-Output "Fibonacci($n) = $fibNumber"
} else {
    Generate-FibonacciSequence
}
