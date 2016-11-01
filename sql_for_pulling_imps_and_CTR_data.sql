SELECT 
dma.dma_geography,
dma.dma_event_date,
pd.pos,
pd.site_section,
pd.portal,
camp.salesgroup,
sum(dma.dma_est_impressions) AS impressions,
sum(dma.dma_est_clicks) AS clicks

FROM "out.c-adops-rs.dma_fact" dma
JOIN "out.c-adops-rs.campaign_dim" camp ON dma.dma_campaign_id = camp.campaign_id
JOIN "out.c-adops-rs.position_dim" pd ON dma.dma_pos_id = pd.id



GROUP BY
dma.dma_geography,
dma.dma_event_date,
pd.pos,
pd.site_section,
pd.portal,
camp.salesgroup

having sum(dma.dma_est_impressions) > 0;

/* country data */

SELECT 
country_name,
country_code,
continent,
state_code,
marine_area,
scf.scf_event_date,
pd.pos,
pd.site_section,
pd.portal,
camp.salesgroup,
sum(scf.scf_est_impressions) AS impressions,
sum(scf.scf_est_clicks) AS clicks

FROM "out.c-adops-rs.state_country_fact" scf
JOIN "out.c-adops-rs.campaign_dim" camp ON scf.scf_campaign_id = camp.campaign_id
JOIN "out.c-adops-rs.position_dim" pd ON scf.scf_pos_id = pd.id
JOIN "out.c-adops-rs.state_country_dim" scd on scf.scf_geograph_id = scd.geography_id 


GROUP BY
country_name,
country_code,
continent,
state_code,
marine_area,
scf.scf_event_date,
pd.pos,
pd.site_section,
pd.portal,
camp.salesgroup
having sum(scf.scf_est_impressions) > 0;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
v.ad_id,
l.product_name,
DATEDIFF(day,l.[Sales_Order_Line_Item_Start_Date],l.[Sales_Order_Line_Item_end_Date]) days_run,
convert(varchar(8),l.[Sales_Order_Line_Item_Start_Date],112) startdate,
convert(varchar(8),l.[Sales_Order_Line_Item_end_Date],112) enddate,
dt.source,
dt.imps,
dt.clicks,
case
	when t.targeting_name in ('BRAND-MAKE-EXCLUDE-search-nia','sales_order_line_item_idBRAND-MAKE-search-ia','BRAND-MAKE-search-nia','CATEGORY-CLASS-TYPE-EXCLUDE-search-nia','CATEGORY-CLASS-TYPE-search-ia','CATEGORY-CLASS-TYPE-search-nia') then 1
	when sli.sales_order_line_item_id is not null then 1
	else 0
end as highly_targeted
  FROM [DataWarehouse_DDM].[dbo].[OO_Sales_Order_Line_Items] l
  join V_Ad_ID_Map v on l.sales_order_line_item_id = v.sales_order_line_item_id
  join V_deliveryTotals dt on v.ad_id = dt.ad_id
  left join [DataWarehouse_DDM].[dbo].[OO_SLI_Text_Targeting] sli on sli.sales_order_line_item_id = l.sales_order_line_item_id
  left join [OO_Sales_Line_Item_Targeting] t on t.sales_order_line_item_id = l.sales_order_line_item_id

where
	case
		when l.Product_Name like '%BTOL%' then 'BTOL'
		when l.Product_Name like '%BO%' then 'BO'
		when l.Product_Name like '%YW%' then 'YW'
		ELSE 'DONOTUSE'
	END <> 'DONOTUSE'
--and SUBSTRING(convert(varchar(8),l.[Sales_Order_Line_Item_Start_Date],112),1,6)  201603
	AND L.Sales_Order_Line_Item_Name NOT LIKE '%CANCEL%'
	AND L.Line_Item_Status <> 'deleted'