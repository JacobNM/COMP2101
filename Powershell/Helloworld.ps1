$todaysDate = $(get-date -UFormat "%A %B %d %Y")

if ((Get-Date).DayOfWeek -eq "Sunday") {
    $Salutation = "Sir"
}

elseif ((Get-Date).DayOfWeek -eq "Monday") {
    $Salutation = "Private"
}

elseif ((Get-Date).DayOfWeek -eq "Tuesday") {
    $Salutation = "Master Chief"
}

elseif ((Get-Date).DayOfWeek -eq "Wednesday") {
    $Salutation = "Monsieur"
}

elseif ((Get-Date).DayOfWeek -eq "Thursday") {
    $Salutation = "Commander"
}

elseif ((Get-Date).DayOfWeek -eq "Friday") {
    $Salutation = "Colonel"
}

elseif ((Get-Date).DayOfWeek -eq "Saturday") {
    $Salutation = "Wingman"
}

Write-Host "Hello $($Salutation)! Todays date is $($todaysDate)"