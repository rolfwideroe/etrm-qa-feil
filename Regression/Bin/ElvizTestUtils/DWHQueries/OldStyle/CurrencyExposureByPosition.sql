DECLARE @workspace varchar(255)
DECLARE @monitor varchar(255)
DECLARE @reportDate varchar(255)


set @workspace='{workspace}'
set @monitor='{monitor}'
set @reportDate='{reportdate}'

SELECT 

       c.RCC_PortfolioName as Portfolio
	   ,c.RCC_Commodity as Commodity
	   ,c.RCC_Instrument as Instrument
	   ,c.RCC_InstPerFrom as FromDate
       ,c.RCC_InstPerTo as ToDate
	   ,c.RCC_InstType as InstrumentType
	   ,c.RCC_DelType as DeliveryType
      ,c.RCC_LoadType as LoadType
      ,c.RCC_Pricebasis as PositionPriceBasis
      ,c.RCC_Executionvenue as ExecutionVenue
      ,c.RCC_TimeZone as TimeZone
      ,c.RCC_Currency as PositionCurrency
      ,c.RCC_CurrSource as PositionCurrencySource
	  
	  ,v.RCV_Currency as ExposureAgainstCurrency
      ,v.RCV_Date as CurrencyExposureDate
      ,v.RCV_CurrencyExposure CurrencyExposure

  FROM RCC_Contracts c
  JOIN RCV_Values v
  on c.RCC_ContractId=v.RCV_RCC_ContractId
      WHERE c.RCC_RCR_ID=(
						SELECT [RCR_ID] FROM RCR_ReportHeader 
						WHERE [RCR_Workspace]=@workspace
						AND [RCR_FrmName]=@monitor
						AND [RCR_RpDate]=@reportDate
					)

   order by c.RCC_ContractId,v.RCV_Currency,v.RCV_Date 