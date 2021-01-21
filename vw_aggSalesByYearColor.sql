USE [AdventureWorksDW2016]
GO

/****** Object:  View [dbo].[vw_aggSalesByYearColor]    Script Date: 21/01/2021 18:00:52 ******/
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_aggSalesByYearColor]
AS
WITH NewFactCurrencyRate AS (SELECT New_fcr.DateKey, New_fcr.AverageRate
                                                     FROM   dbo.FactCurrencyRate AS New_fcr LEFT OUTER JOIN
                                                                  dbo.DimCurrency AS dc ON dc.CurrencyKey = New_fcr.CurrencyKey
                                                     WHERE (dc.CurrencyAlternateKey = 'NZD'))
    SELECT YEAR(fso.OrderDate) AS 'Calendar Year', dp.Color AS 'Product Color', SUM(fso.SalesAmount / fcr.AverageRate) AS 'Total sales amount in US Dollars', SUM(fso.OrderQuantity) AS 'Total Quantity ordered', SUM(fso.SalesAmount / fcr.AverageRate * New_fcr.AverageRate) 
                AS 'Total sales amount in New Zealand Dollars'
   FROM    dbo.FactSalesOrder AS fso INNER JOIN
                dbo.DimProduct AS dp ON fso.ProductKey = dp.ProductKey INNER JOIN
                dbo.FactCurrencyRate AS fcr ON fcr.CurrencyKey = fso.CurrencyKey AND fcr.DateKey = fso.OrderDateKey LEFT OUTER JOIN
                NewFactCurrencyRate AS New_fcr ON fcr.DateKey = fso.OrderDateKey
   GROUP BY YEAR(fso.OrderDate), dp.Color
GO



