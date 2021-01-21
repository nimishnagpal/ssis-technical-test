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


## How Package Works
Once package is configured and Package Parameters have the new system value, the package can be triggered by click `Start` (or press `F5`). The package has ***4 Control Flow tasks***. Each task performs its functionality. 

#### Get exchange rates from API
The taks calls a powershell script to fetch the exchanges rates from Web - https://exchangeratesapi.io/ and loads it into a csv file. The api call is driven with variables like
- `startDate`
- `endData` 
- `base` currency 
- `symbol` as required required currency 


> ***Alternate ways of getting the exchange rate*** could be
> 1. Use **Script Task** and writing C# or VB in  *.Net Framework* to fetch the exchange rate through WebClient and then loading it into the table.
> 2. Use **Web Service Task** to call the WebAPI and store the output in the file. This method require to *download WSDL(Web Service Definition Language)* from the Web source.  

#### Load Sales_NewCurencyRate
This task loads the currency rates from the Flat File downloaded from the above task and then transforms the data to proper data types and load it into newly created table `AdventureWorks2016.Sales.NewCurencyRate` in the OLTP database. 

#### Load New FXRates into FactCurrencyRate
This task contains a SQL Script. The purpose to using this task it to bring proper structures information for the enchangerate. 

>The ***issue with the exchangerate coming from the WebAPI*** is that exchange rate are not continuous and some of the days are missing. So, the script load the exchange rate for all the relevant date while filling the the previous days exchange rate in case it is missing.

#### Load FactSalesOrder
This is most important data flow task of the package, where the data is read from `Sales.SalesOrderDetail` and `Sales.SalesOrderHeader` to retrive the Order details. Using the SalesOrders,  a new Fact table is loaded `AdventureWorksDW2016.dbo.FactSalesOrders`. This fact table recieves the Keys from DimProduct and DimCurrency and some derived columns that calculated a few of the required fact information.

## Additional Features
A few of the additional feature are added to the package for better usage.

### Event Handler
An event handler **onPreValidation** of the task `Load FactSalesOrder`and `Load Sales_NewCurencyRate` are added to avoid failure becasue the task within these event handler will `Check if the require table exists and accordingly creates the table`.
![EventHandler]()

### Logging OnFailure & OnWarning
Logging mechanism is enabled to allow log the failures and the warning on any of the tasks.

### Allow ONLY latest records and Decide to Insert Or Update record
The source components in task `Load FactSalesOrder` *determines the records that are NOT process* and allow those ONLY to flow through the data flow task. Also the Lookup with the destination table allow the package to decide whether `the record New record (therefore Insert)` OR is `an existing record (therefore Update)`





