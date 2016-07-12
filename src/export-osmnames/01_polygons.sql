CREATE MATERIALIZED VIEW mv_polygons AS
SELECT getLanguageName(r.name, r.name_fr, r.name_en, r.name_de, r.name_es, r.name_ru, r.name_zh) AS name,
    city_class(r.type) AS class,
    r.type AS type,
    ST_X(ST_PointOnSurface(ST_Transform(r.geometry, 4326))) AS lon,
    ST_Y(ST_PointOnSurface(ST_Transform(r.geometry, 4326))) AS lat,
    r.rank_search AS place_rank,
    getImportance(r.rank_search, r.wikipedia, r.calculated_country_code) AS importance,
    ''::TEXT AS street,
    parentInfo.city AS city,
    parentInfo.county  AS county,
    parentInfo.state  AS state,
    countryName(r.partition) AS country,
    r.calculated_country_code AS country_code,
    parentInfo.displayName  AS display_name,  
    ST_XMIN(ST_Transform(r.geometry, 4326)) AS west,
    ST_YMIN(ST_Transform(r.geometry, 4326)) AS south,
    ST_XMAX(ST_Transform(r.geometry, 4326)) AS east,
    ST_YMAX(ST_Transform(r.geometry, 4326)) AS north,
    getWikipediaURL(r.wikipedia, r.calculated_country_code) AS wikipedia
FROM osm_polygon AS r , getParentInfo(getLanguageName(name, name_fr, name_en, name_de, name_es, name_ru, name_zh), parent_id, rank_search, ',') AS parentInfo
;