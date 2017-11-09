/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @workspace varchar(255)
DECLARE @monitor varchar(255)
DECLARE @reportDate varchar(255)

set @workspace='{workspace}'
set @monitor='{monitor}'
set @reportDate='{reportdate}'

SELECT 


       c.RMC_PortfolioName as Portfolio
	   ,c.RMC_Commodity as Commodity
	   ,c.RMC_Instrument as Instrument
	   ,c.RMC_InstPerFrom as FromDate
       ,c.RMC_InstPerTo as ToDate
	   ,c.RMC_InstType as InstrumentType
	   ,c.RMC_DelType as DeliveryType
      ,c.RMC_LoadType as LoadType
      ,c.RMC_Pricebasis as PositionPriceBasis
      ,c.RMC_Executionvenue as ExecutionVenue
      ,c.RMC_TimeZone as TimeZone
      ,c.RMC_Currency as PositionCurrency
      ,c.RMC_CurrSource as PositionCurrencySource

	   ,e.RMV_PriceBasisName as ExposurePriceBasis
	   ,RMV_Unit as ExposureUnit
      ,RMV_FromTime as ExposureFromTime
      ,RMV_UntilTime as ExposureToTime
      ,RMV_Exposure as BaseExposure
      ,RMV_PeakExposure as PeakExposure
      ,RMV_OffPeakExposure as OffPeakExposure
      ,RMV_Price as BasePrice
      ,RMV_PeakPrice as PeakPrice
      ,RMV_OffPeakPrice as OffPeakPrice

  FROM RMC_Contracts c
  JOIN RMV_Values e 
  ON c.RMC_ContractId=e.RMV_RMC_ContractId
    WHERE c.RMC_RMR_ID=(
						SELECT [RMR_ID] FROM [RMR_ReportHeader] 
						WHERE [RMR_Workspace]=@workspace
						AND [RMR_FrmName]=@monitor
						AND [RMR_RpDate]=@reportDate
					)
 ORDER BY c.RMC_ContractId, e.RMV_PriceBasisName,e.RMV_FromTime