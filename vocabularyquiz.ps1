# Author: Bennett Atkinson
# Program: vocabularyquiz.ps1
# Date: 2025-10-29
# Version: 1.0
# Purpose: Reads word-definition pairs from a specified file organized by topics and displays them randomly.

param(
    [string]$Topic = "All",  # Default to all topics, space or comma separated for multiple
    [string]$Order = "Random",  # Word order: Random or List
    [string]$File = "wordlist.txt",  # Input file with word-definition pairs
    [switch]$Help  # Show help information
)

# Display help if requested
if ($Help) {
    Write-Host "Vocabulary Quiz - Help" -ForegroundColor Cyan
    Write-Host "=====================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Command Line Arguments:" -ForegroundColor Yellow
    Write-Host "  -File <FileName>          Input file containing word-definition pairs." -ForegroundColor Green
    Write-Host "                            Default: 'wordlist.txt'" -ForegroundColor Gray
    Write-Host "  -Topic <TopicName>        Select topic(s). Use spaces or commas for multiple." -ForegroundColor Green
    Write-Host "                            Examples: 'Animals' or 'Animals,Colors' or 'Animals Colors'" -ForegroundColor Gray
    Write-Host "                            Default: 'All' (all topics)" -ForegroundColor Gray
    Write-Host "  -Order <OrderType>        Set word order: 'Random' or 'List'" -ForegroundColor Green
    Write-Host "                            Random: Words shown in random order" -ForegroundColor Gray
    Write-Host "                            List: Words shown in sequential order from file" -ForegroundColor Gray
    Write-Host "                            Default: 'Random'" -ForegroundColor Gray
    Write-Host "  -Help                     Display this help information" -ForegroundColor Green
    Write-Host ""
    Write-Host "Quiz Commands (available after seeing translation):" -ForegroundColor Yellow
    Write-Host "  info                      Display the quiz header with current settings" -ForegroundColor Green
    Write-Host "  topic                     Switch topics interactively" -ForegroundColor Green
    Write-Host "  topic <TopicName>         Switch to specific topic(s)" -ForegroundColor Green
    Write-Host "                            Examples: 'topic Animals' or 'topic Animals Colors'" -ForegroundColor Gray
    Write-Host "  order                     Switch word order interactively (Random/List)" -ForegroundColor Green
    Write-Host "  order random              Switch to random order" -ForegroundColor Green
    Write-Host "  order list                Switch to list order" -ForegroundColor Green
    Write-Host "  refresh                   Reload the word list from file" -ForegroundColor Green
    Write-Host "  restart                   Restart the current topic" -ForegroundColor Green
    Write-Host "  help                      Display this help information" -ForegroundColor Green
    Write-Host "  quit or exit              Stop the quiz" -ForegroundColor Green
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\vocabularyquiz.ps1" -ForegroundColor Gray
    Write-Host "  .\vocabularyquiz.ps1 -Topic Animals" -ForegroundColor Gray
    Write-Host "  .\vocabularyquiz.ps1 -File vocabulary.txt -Topic Animals" -ForegroundColor Gray
    Write-Host "  .\vocabularyquiz.ps1 -File custom.txt -Topic 'Animals Colors' -Order List" -ForegroundColor Gray
    Write-Host "  .\vocabularyquiz.ps1 -Help" -ForegroundColor Gray
    Write-Host ""
    exit
}


if (-not (Test-Path $File)) {
    Write-Host "Error: File '$File' not found in the current directory." -ForegroundColor Red
    exit
}

# Read all lines from the file
$lines = @(Get-Content $File | Where-Object {$_.Trim() -ne ""})

# Check if file has content
if ($lines.Count -eq 0) {
    Write-Host "Error: woord.txt is empty." -ForegroundColor Red
    exit
}

# Parse word-definition pairs with topics
$allPairs = @()
$currentTopic = "General"
$topics = @{}

foreach ($line in $lines) {
    # Check if line is a topic header [topic]
    if ($line -match "^\s*\[(.+)\]\s*$") {
        $currentTopic = $matches[1]
        $topics[$currentTopic] = @()
    }
    elseif ($line -like "*:*") {
        $parts = $line -split ":", 2  # Split on first colon only
        $word = $parts[0].Trim()
        $definition = $parts[1].Trim()
        $pair = @{Word = $word; Definition = $definition; Topic = $currentTopic}
        $allPairs += $pair
        
        if (-not $topics.ContainsKey($currentTopic)) {
            $topics[$currentTopic] = @()
        }
        $topics[$currentTopic] += $pair
    }
}

# Filter pairs based on selected topics
$pairs = @()
$selectedTopicNames = @()

# Check if "All" 
if ($Topic.ToLower() -eq "all" -or $Topic -eq "*") {
    $pairs = $allPairs
    $TopicDisplay = "All"
}
else {
    # Split topics by spaces or commas
    $topicNames = $Topic -split "[\s,]+" | Where-Object {$_ -ne ""}
    
    # Handle multiple topics
    foreach ($topicName in $topicNames) {
        # Case-insensitive topic matching
        $matchedTopic = $topics.Keys | Where-Object {$_ -eq $topicName}
        if ($null -eq $matchedTopic) {
            $matchedTopic = $topics.Keys | Where-Object {$_.ToLower() -eq $topicName.ToLower()}
        }
        
        if ($null -ne $matchedTopic) {
            $pairs += $topics[$matchedTopic]
            $selectedTopicNames += $matchedTopic
        }
        else {
            Write-Host "Error: Topic '$topicName' not found." -ForegroundColor Red
            Write-Host "Available topics: " -ForegroundColor Yellow -NoNewline
            Write-Host ($topics.Keys -join ", ") -ForegroundColor Cyan
            Write-Host "Use 'All' to include all topics." -ForegroundColor Yellow
            exit
        }
    }
    $TopicDisplay = $selectedTopicNames -join ", "
}

# Validate and set word order
$OrderDisplay = $Order
if ($Order.ToLower() -eq "random" -or $Order.ToLower() -eq "r") {
    $OrderDisplay = "Random"
    # Shuffle the pairs
    $pairs = $pairs | Sort-Object {Get-Random}
}
elseif ($Order.ToLower() -eq "list" -or $Order.ToLower() -eq "l") {
    $OrderDisplay = "List"
    # Keep in list order (no shuffling)
}
else {
    Write-Host "Error: Order must be 'Random' or 'List'." -ForegroundColor Red
    exit
}

if ($pairs.Count -eq 0) {
    Write-Host "Error: No valid word-definition pairs found. Format should be: word: definition" -ForegroundColor Red
    exit
}

Write-Host "Vocabulary Quiz" -ForegroundColor Cyan
Write-Host "===============" -ForegroundColor Cyan
if ($TopicDisplay -eq "All") {
    Write-Host "Available topics: " -ForegroundColor Yellow -NoNewline
    Write-Host ($topics.Keys -join ", ") -ForegroundColor Cyan
}
Write-Host "Topic: " -ForegroundColor Gray -NoNewline
Write-Host $TopicDisplay -ForegroundColor Green
Write-Host "Order: " -ForegroundColor Gray -NoNewline
Write-Host $OrderDisplay -ForegroundColor Green
Write-Host "Word Count: " -ForegroundColor Gray -NoNewline
Write-Host $pairs.Count -ForegroundColor Green
Write-Host "Type 'quit' or 'exit' to stop the quiz." -ForegroundColor Yellow
Write-Host "Type 'info' to see the quiz header again." -ForegroundColor Yellow
Write-Host "Type 'topic' to switch topics, or 'topic Topic1 Topic2' for multiple." -ForegroundColor Yellow
Write-Host "Type 'order' to change word order (random or list)." -ForegroundColor Yellow
Write-Host "Type 'help' for detailed command information.`n" -ForegroundColor Yellow

$headerDisplay = {
    Write-Host ""
    Write-Host "Vocabulary Quiz" -ForegroundColor Cyan
    Write-Host "===============" -ForegroundColor Cyan
    if ($TopicDisplay -eq "All") {
        Write-Host "Available topics: " -ForegroundColor Yellow -NoNewline
        Write-Host ($topics.Keys -join ", ") -ForegroundColor Cyan
    }
    Write-Host "Topic: " -ForegroundColor Gray -NoNewline
    Write-Host $TopicDisplay -ForegroundColor Green
    Write-Host "Order: " -ForegroundColor Gray -NoNewline
    Write-Host $OrderDisplay -ForegroundColor Green
    Write-Host "Word Count: " -ForegroundColor Gray -NoNewline
    Write-Host $pairs.Count -ForegroundColor Green
    Write-Host ""
}

# Function to switch topics
function Switch-Topic {
    param(
        [string]$NewTopicName = ""
    )
    
    if ($NewTopicName -eq "") {
        # Interactive mode
        Write-Host ""
        Write-Host "Available topics: " -ForegroundColor Yellow -NoNewline
        Write-Host ($topics.Keys -join ", ") -ForegroundColor Cyan
        $newTopic = Read-Host "Enter topic name(s) separated by spaces (or 'All')"
    }
    else {
        $newTopic = $NewTopicName
    }
    
    if ($newTopic.ToLower() -eq "all" -or $newTopic -eq "*") {
        $script:pairs = $allPairs
        $script:TopicDisplay = "All"
        Write-Host "Switched to topic: " -ForegroundColor Green -NoNewline
        Write-Host "All" -ForegroundColor Cyan
    }
    else {
        # Split the input into multiple topics
        $topicNames = $newTopic -split "\s+" | Where-Object {$_ -ne ""}
        $combinedPairs = @()
        $matchedTopics = @()
        
        foreach ($topicName in $topicNames) {
            # Case-insensitive topic matching
            $matchedTopic = $topics.Keys | Where-Object {$_ -eq $topicName}
            if ($null -eq $matchedTopic) {
                $matchedTopic = $topics.Keys | Where-Object {$_.ToLower() -eq $topicName.ToLower()}
            }
            
            if ($null -ne $matchedTopic) {
                $combinedPairs += $topics[$matchedTopic]
                $matchedTopics += $matchedTopic
            }
            else {
                Write-Host "Error: Topic '$topicName' not found." -ForegroundColor Red
                return $false
            }
        }
        
        if ($combinedPairs.Count -gt 0) {
            $script:pairs = $combinedPairs
            $script:TopicDisplay = $matchedTopics -join ", "
            Write-Host "Switched to topic(s): " -ForegroundColor Green -NoNewline
            Write-Host ($matchedTopics -join ", ") -ForegroundColor Cyan
        }
    }
    Write-Host "Word Count: " -ForegroundColor Gray -NoNewline
    Write-Host $pairs.Count -ForegroundColor Green
    Write-Host ""
    $script:pairIndex = 0  # Reset pair index when switching topics
    return $true
}

# Function to switch word order
function Switch-Order {
    param(
        [string]$NewOrder = ""
    )
    
    if ($NewOrder -eq "") {
        # Interactive mode
        Write-Host ""
        $newOrder = Read-Host "Enter order: 'Random' or 'List'"
    }
    else {
        $newOrder = $NewOrder
    }
    
    if ($newOrder.ToLower() -eq "random" -or $newOrder.ToLower() -eq "r") {
        $script:OrderDisplay = "Random"
        # Shuffle the pairs
        $script:pairs = $script:pairs | Sort-Object {Get-Random}
        Write-Host "Switched to order: " -ForegroundColor Green -NoNewline
        Write-Host "Random" -ForegroundColor Cyan
    }
    elseif ($newOrder.ToLower() -eq "list" -or $newOrder.ToLower() -eq "l") {
        $script:OrderDisplay = "List"
        # For list order, we need to restore from allPairs filtered by current topics
        # Re-apply topic filtering without shuffling
        $script:pairs = @()
        $selectedTopics = $TopicDisplay -split ", "
        
        if ($TopicDisplay -eq "All") {
            $script:pairs = $allPairs
        }
        else {
            foreach ($topic in $selectedTopics) {
                if ($topics.ContainsKey($topic)) {
                    $script:pairs += $topics[$topic]
                }
            }
        }
        Write-Host "Switched to order: " -ForegroundColor Green -NoNewline
        Write-Host "List" -ForegroundColor Cyan
    }
    else {
        Write-Host "Error: Order must be 'Random' or 'List'." -ForegroundColor Red
        return $false
    }
    Write-Host ""
    $script:pairIndex = 0  # Reset pair index when switching order
    return $true
}

# Function to refresh/reload the word list from file
function Refresh-WordList {
    Write-Host ""
    
    # Check if file exists
    if (-not (Test-Path $File)) {
        Write-Host "Error: File '$File' not found." -ForegroundColor Red
        return $false
    }
    
    # Read all lines from the file
    $lines = @(Get-Content $File | Where-Object {$_.Trim() -ne ""})
    
    # Check if file has content
    if ($lines.Count -eq 0) {
        Write-Host "Error: File is empty." -ForegroundColor Red
        return $false
    }
    
    # Parse word-definition pairs with topics
    $script:allPairs = @()
    $currentTopic = "General"
    $script:topics = @{}
    
    foreach ($line in $lines) {
        # Check if line is a topic header [topic]
        if ($line -match "^\s*\[(.+)\]\s*$") {
            $currentTopic = $matches[1]
            $script:topics[$currentTopic] = @()
        }
        elseif ($line -like "*:*") {
            $parts = $line -split ":", 2  # Split on first colon only
            $word = $parts[0].Trim()
            $definition = $parts[1].Trim()
            $pair = @{Word = $word; Definition = $definition; Topic = $currentTopic}
            $script:allPairs += $pair
            
            if (-not $script:topics.ContainsKey($currentTopic)) {
                $script:topics[$currentTopic] = @()
            }
            $script:topics[$currentTopic] += $pair
        }
    }
    
    # Reapply current topic filter
    $script:pairs = @()
    
    if ($TopicDisplay -eq "All") {
        $script:pairs = $script:allPairs
    }
    else {
        # Split current topics
        $topicNames = $TopicDisplay -split "," | ForEach-Object {$_.Trim()}
        
        foreach ($topicName in $topicNames) {
            # Case-insensitive topic matching
            $matchedTopic = $script:topics.Keys | Where-Object {$_.ToLower() -eq $topicName.ToLower()}
            
            if ($null -ne $matchedTopic) {
                $script:pairs += $script:topics[$matchedTopic]
            }
        }
    }
    
    # Reapply current order setting
    if ($OrderDisplay -eq "Random") {
        $script:pairs = $script:pairs | Sort-Object {Get-Random}
    }
    
    Write-Host "Word list refreshed successfully" -ForegroundColor Green
    Write-Host "Word Count: " -ForegroundColor Gray -NoNewline
    Write-Host $script:pairs.Count -ForegroundColor Green
    Write-Host ""
    $script:pairIndex = 0  # Reset pair index
    return $true
}

# Function to restart the current topic
function Restart-Topic {
    Write-Host ""
    
    # Reshuffle if in random mode
    if ($OrderDisplay -eq "Random") {
        $script:pairs = $script:pairs | Sort-Object {Get-Random}
    }
    
    # Reset pair index
    $script:pairIndex = 0
    
    Write-Host "Topic restarted" -ForegroundColor Green
    Write-Host "Topic: " -ForegroundColor Gray -NoNewline
    Write-Host $TopicDisplay -ForegroundColor Green
    Write-Host "Order: " -ForegroundColor Gray -NoNewline
    Write-Host $OrderDisplay -ForegroundColor Green
    Write-Host "Word Count: " -ForegroundColor Gray -NoNewline
    Write-Host $script:pairs.Count -ForegroundColor Green
    Write-Host ""
    return $true
}

# Function to display help during quiz
function Display-Help {
    Write-Host ""
    Write-Host "Vocabulary Quiz - Commands" -ForegroundColor Cyan
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Quiz Commands:" -ForegroundColor Yellow
    Write-Host "  Commands are available ONLY after viewing the translation" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  info                      Display the quiz header with current settings" -ForegroundColor Green
    Write-Host "  topic                     Switch topics interactively" -ForegroundColor Green
    Write-Host "  topic <TopicName>         Switch to specific topic(s)" -ForegroundColor Green
    Write-Host "                            Examples: 'topic Animals' or 'topic Animals Colors'" -ForegroundColor Gray
    Write-Host "  order                     Switch word order interactively (Random/List)" -ForegroundColor Green
    Write-Host "  order random              Switch to random order" -ForegroundColor Green
    Write-Host "  order list                Switch to list order" -ForegroundColor Green
    Write-Host "  refresh                   Reload the word list from file" -ForegroundColor Green
    Write-Host "  restart                   Restart the current topic" -ForegroundColor Green
    Write-Host "  help                      Display this help information" -ForegroundColor Green
    Write-Host "  quit or exit              Stop the quiz" -ForegroundColor Green
    Write-Host ""
    Write-Host "Current Settings:" -ForegroundColor Yellow
    Write-Host "  Topic: " -ForegroundColor Gray -NoNewline
    Write-Host $TopicDisplay -ForegroundColor Green
    Write-Host "  Order: " -ForegroundColor Gray -NoNewline
    Write-Host $OrderDisplay -ForegroundColor Green
    Write-Host ""
}

# Initialize pair index for list order mode
$pairIndex = 0

# Main quiz loop
while ($true) {
    # Pick a pair based on order mode
    if ($OrderDisplay -eq "Random") {
        $randomPair = $pairs | Get-Random
    }
    else {
        # List mode - cycle through pairs
        $randomPair = $pairs[$pairIndex]
        $pairIndex = ($pairIndex + 1) % $pairs.Count
    }
    
    # Display the word
    Write-Host "Word: " -ForegroundColor Cyan -NoNewline
    Write-Host $randomPair.Word -ForegroundColor Green -BackgroundColor Black -NoNewline
    Write-Host " - Press Enter to see the translation..." -ForegroundColor Gray -NoNewline
    
    # Wait for Enter key only - ignore any other input
    do {
        $key = $host.UI.RawUI.ReadKey("NoEcho")
    } while ($key.VirtualKeyCode -ne 13)  # 13 is the Enter/Return key
    
    Write-Host ""  # New line after key press
    
    # Display the translation/definition
    Write-Host "Translation: " -ForegroundColor Cyan -NoNewline
    Write-Host $randomPair.Definition -ForegroundColor Yellow
    Write-Host "Press Enter for the next word or enter a command..." -ForegroundColor Gray -NoNewline
    $response = Read-Host
    
    # Check for commands
    while ($response -match "^topic" -or $response -match "^order" -or $response -eq "info" -or $response -eq "help" -or $response -eq "refresh" -or $response -eq "restart") {
        if ($response -eq "info") {
            & $headerDisplay
        }
        elseif ($response -eq "help") {
            Display-Help
        }
        elseif ($response -eq "refresh") {
            Refresh-WordList
        }
        elseif ($response -eq "restart") {
            Restart-Topic
        }
        elseif ($response -match "^topic") {
            # Check if argument provided
            if ($response -match "^topic\s+(.+)$") {
                $topicArg = $matches[1]
                Switch-Topic -NewTopicName $topicArg
            }
            else {
                # Interactive mode
                Switch-Topic
            }
        }
        elseif ($response -match "^order") {
            # Check if argument provided
            if ($response -match "^order\s+(.+)$") {
                $orderArg = $matches[1]
                Switch-Order -NewOrder $orderArg
            }
            else {
                # Interactive mode
                Switch-Order
            }
        }
        Write-Host "Press Enter for the next word or enter a command..." -ForegroundColor Gray -NoNewline
        $response = Read-Host
        
        # Break if user just hit Enter with no command
        if ([string]::IsNullOrWhiteSpace($response)) {
            break
        }
    }
    
    # Check if user wants to quit
    if ($response -eq "quit" -or $response -eq "exit") {
        Write-Host "Thanks for studying!" -ForegroundColor Cyan
        break
    }
    
    Write-Host ""
}
