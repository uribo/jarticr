# JARTIC data providers

The organisations that publish JARTIC open data: the 47 prefectures,
with Hokkaido split into its 5 police headquarters areas.

## Usage

``` r
jartic_provider
```

## Format

A tibble with 51 rows and 2 variables:

- name:

  Provider name in Japanese.

- name_en:

  Provider name in roman letters, as used in file paths.

## Source

<https://www.jartic.or.jp/service/opendata/>

## Examples

``` r
jartic_provider
#> # A tibble: 51 × 2
#>    name             name_en  
#>    <chr>            <chr>    
#>  1 北海道(札幌方面) sapporo  
#>  2 北海道(函館方面) hakodate 
#>  3 北海道(旭川方面) asahikawa
#>  4 北海道(釧路方面) kushiro  
#>  5 北海道(北見方面) kitami   
#>  6 青森県           aomori   
#>  7 岩手県           iwate    
#>  8 宮城県           miyagi   
#>  9 秋田県           akita    
#> 10 山形県           yamagata 
#> # ℹ 41 more rows
```
