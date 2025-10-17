# Import Update Script - Updates all import statements to use the new feature-based structure

Write-Host "Updating imports to feature-based structure..." -ForegroundColor Green

$basePath = "c:\_cmps312-content\examples\09_state_management\state_management\lib"

# Define replacement mappings
$importMappings = @{
    'lib/providers/counter_provider.dart' = 'lib/features/counter/counter_provider.dart'
    'lib/screens/counter_screen.dart' = 'lib/features/counter/counter_screen.dart'
    'lib/widgets/click_counter.dart' = 'lib/features/counter/click_counter.dart'
    'lib/models/weather.dart' = 'lib/features/weather/weather_model.dart'
    'lib/providers/weather_provider.dart' = 'lib/features/weather/weather_provider.dart'
    'lib/screens/weather_screen.dart' = 'lib/features/weather/weather_screen.dart'
    'lib/models/news_article.dart' = 'lib/features/news/news_model.dart'
    'lib/providers/news_provider.dart' = 'lib/features/news/news_provider.dart'
    'lib/screens/news_screen.dart' = 'lib/features/news/news_screen.dart'
    'lib/models/todo.dart' = 'lib/features/todos/models/todo.dart'
    'lib/providers/todo_list_provider.dart' = 'lib/features/todos/providers/todo_list_provider.dart'
    'lib/providers/todo_filter_provider.dart' = 'lib/features/todos/providers/todo_filter_provider.dart'
    'lib/repositories/todo_repository.dart' = 'lib/features/todos/repositories/todo_repository.dart'
    'lib/widgets/add_todo_field.dart' = 'lib/features/todos/widgets/add_todo_field.dart'
    'lib/widgets/todo_tile.dart' = 'lib/features/todos/widgets/todo_tile.dart'
    'lib/widgets/todo_toolbar.dart' = 'lib/features/todos/widgets/todo_toolbar.dart'
    'lib/screens/todo_list.dart' = 'lib/features/todos/todo_screen.dart'
    'lib/models/product.dart' = 'lib/features/products/models/product.dart'
    'lib/models/category.dart' = 'lib/features/products/models/category.dart'
    'lib/providers/products_provider.dart' = 'lib/features/products/providers/products_provider.dart'
    'lib/providers/categories_provider.dart' = 'lib/features/products/providers/categories_provider.dart'
    'lib/providers/selected_category_provider.dart' = 'lib/features/products/providers/selected_category_provider.dart'
    'lib/repositories/product_repository.dart' = 'lib/features/products/repositories/product_repository.dart'
    'lib/widgets/product_tile.dart' = 'lib/features/products/widgets/product_tile.dart'
    'lib/screens/products_list.dart' = 'lib/features/products/products_screen.dart'
    'lib/models/fruit.dart' = 'lib/features/fruits/fruit_model.dart'
    'lib/providers/fruits_provider.dart' = 'lib/features/fruits/fruits_provider.dart'
    'lib/repositories/fruit_repository.dart' = 'lib/features/fruits/fruit_repository.dart'
    'lib/widgets/fruit_tile.dart' = 'lib/features/fruits/widgets/fruit_tile.dart'
    'lib/screens/fruits_list.dart' = 'lib/features/fruits/fruits_screen.dart'
    'lib/screens/fruit_detail.dart' = 'lib/features/fruits/fruit_detail_screen.dart'
    'lib/providers/app_config_provider.dart' = 'lib/features/app_config/app_config_provider.dart'
    'lib/screens/app_config_screen.dart' = 'lib/features/app_config/app_config_screen.dart'
    'lib/screens/home_screen.dart' = 'lib/core/home_screen.dart'
}

function Update-ImportsInFile {
    param ([string]$filePath)
    
    if (-not (Test-Path $filePath)) { return }
    
    $content = Get-Content $filePath -Raw
    $updated = $false
    
    foreach ($oldPath in $importMappings.Keys) {
        $newPath = $importMappings[$oldPath]
        $oldImport = "package:state_management/$oldPath"
        $newImport = "package:state_management/$newPath"
        
        if ($content -match [regex]::Escape($oldImport)) {
            $content = $content -replace [regex]::Escape($oldImport), $newImport
            $updated = $true
        }
    }
    
    if ($updated) {
        Set-Content -Path $filePath -Value $content -NoNewline
        Write-Host "  Updated: $filePath" -ForegroundColor Green
    }
}

Write-Host "`nUpdating feature files..." -ForegroundColor Yellow
Get-ChildItem -Path "$basePath\features" -Filter "*.dart" -Recurse | ForEach-Object {
    Update-ImportsInFile $_.FullName
}

Write-Host "`nUpdating core files..." -ForegroundColor Yellow
Get-ChildItem -Path "$basePath\core" -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    Update-ImportsInFile $_.FullName
}

Write-Host "`nUpdating main files..." -ForegroundColor Yellow
Update-ImportsInFile "$basePath\main.dart"
Update-ImportsInFile "$basePath\router.dart"

Write-Host "`nImport updates complete!" -ForegroundColor Green
Write-Host "Run flutter pub get to verify." -ForegroundColor Cyan
