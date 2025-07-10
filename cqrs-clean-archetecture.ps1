# Prompt user for project name
$projectName = Read-Host "Enter the name of your solution/project"

Write-Host "About to create the $projectName solution directory" -ForegroundColor Green

# Create root folder and enter it
mkdir $projectName
cd $projectName

Write-Host "Creating solution and projects" -ForegroundColor Green
# Initialize solution
dotnet new sln -n $projectName

# Create projects
dotnet new webapi -n API --use-controllers
dotnet new classlib -n Application
dotnet new classlib -n Domain
dotnet new classlib -n Persistence
dotnet new classlib -n Infrastructure

Write-Host "Creating folder structure within Infrastructure project" -ForegroundColor Green

# Folder structure inside Infrastructure
$infraPath = "Infrastructure\BackgroundServices"
mkdir "$infraPath"
mkdir "$infraPath\Scheduler"
mkdir "$infraPath\Jobs"
mkdir "$infraPath\Jobs\HeavyDataSync"
mkdir "$infraPath\Jobs\HeavyDataSync\Mappers"
mkdir "$infraPath\Jobs\HeavyDataSync\Validators"
mkdir "$infraPath\Jobs\AnotherJob"
mkdir "$infraPath\Interfaces"

# Placeholder files
New-Item "$infraPath\Scheduler\CronExpressionParser.cs" -ItemType File
New-Item "$infraPath\Scheduler\NextRunCalculator.cs" -ItemType File
New-Item "$infraPath\Jobs\HeavyDataSync\HeavyDataSyncJob.cs" -ItemType File
New-Item "$infraPath\Jobs\HeavyDataSync\HeavyDataSyncRunner.cs" -ItemType File
New-Item "$infraPath\Jobs\HeavyDataSync\Mappers\README.txt" -ItemType File
New-Item "$infraPath\Jobs\HeavyDataSync\Validators\README.txt" -ItemType File
New-Item "$infraPath\Interfaces\IBackgroundJob.cs" -ItemType File
New-Item "$infraPath\Interfaces\IJobScheduler.cs" -ItemType File
New-Item "$infraPath\Interfaces\IHeavyDataSyncRunner.cs" -ItemType File
New-Item "Infrastructure\BackgroundServices\CronJobService.cs" -ItemType File

Write-Host "Adding projects to the solution" -ForegroundColor Green
dotnet sln add API/API.csproj
dotnet sln add Application/Application.csproj
dotnet sln add Domain/Domain.csproj
dotnet sln add Persistence/Persistence.csproj
dotnet sln add Infrastructure/Infrastructure.csproj

Write-Host "Adding project references" -ForegroundColor Green
cd API
dotnet add reference ../Application/Application.csproj
dotnet add reference ../Infrastructure/Infrastructure.csproj
cd ..

cd Application
dotnet add reference ../Domain/Domain.csproj
cd ..

cd Persistence
dotnet add reference ../Domain/Domain.csproj
cd ..

cd Infrastructure
dotnet add reference ../Persistence/Persistence.csproj
dotnet add reference ../Domain/Domain.csproj
cd ..

Write-Host "Restoring all projects" -ForegroundColor Green
dotnet restore

Write-Host "Your Clean CQRS solution scaffold with infrastructure background service is ready!" -ForegroundColor Green
