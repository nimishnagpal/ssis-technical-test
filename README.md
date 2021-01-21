# ssis-technical-test


<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Configure The Solution</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



## About The Project
The package is build to accomodate the business scenario where the requirement is to have a FACT table in the AdventureWorksDW which allows to query to aggregate `Total sales amount in New Zealand Dollars`, `Total sales amount in US Dollars`, `Total Quantity ordered` to be grouped upon the `Calendar Year of Order` and the `Colour of the Product`.

### Built With

* SQL Server Databases : AdventureWorks2016 & AdventureWorksDW2016.
* Visual Studio 2019 with installed SSIS Project extension.
* Powershell Script.


## Getting Started
Best way to use the package is to either clone the repository to your local system or Download the solution as zip file. The repo has **solution package**  and a additional **SQL Script**. 

Staring with **solution package**, you must meet the Prerequisites before you run the package. 

### Prerequisites
Here are the list of softwares and packages you will need to install.
* Install [Visual Studio 2015](https://visualstudio.microsoft.com/vs/older-downloads/) or neawer (Recommended)  OR Install [SSDT version15](https://docs.microsoft.com/en-us/sql/ssdt/previous-releases-of-sql-server-data-tools-ssdt-and-ssdt-bi?view=sql-server-ver15) or newer. (Recommended)
* [SQL Server Management Studio 2016](https://docs.microsoft.com/en-us/sql/ssms/release-notes-ssms?view=sql-server-ver15) or Newer (Recommended)
* [AdventureWorks databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms) any

### Configure The Solution 
Open the `ssis-technical-test.sln` on your local machine. It will open the visual studio or SSDT.  Open the package `Load FactSalesOrder.dtsx` from the *Solution Explorer*. Edit the package paramters as you open the package.

![PackageParameters](https://github.com/NimNagpal/Daemon/blob/master/screenshots/PackageParameter.png?raw=true)

Make sure you provide the `ProjectPath`, which is the path of the directory of the project file. The parameters `serverName`, `OLTPdatabase` & `DWdatabase` are filled as per the server name and databasename in your local machine.

> NOTE: I am assuming that the Adventure Works is installed on your local machine and it doesn't require passowrd to connect. If not the case package configurations will need to change. 

> While opening the package `Load FactSalesOrder.dtsx` for the first time it might raise an *ERROR MESSAGE*. Continue opening the package and provide the Package Parameters. It will fix the error 



