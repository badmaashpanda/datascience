    -- Find the number of processed and non-processed complaints of each type.
    -- Replace NULL values with 0s.
    -- Output the complaint type along with the number of processed and not-processed complaints.

    select type, count(c_p) as n_comp_processed, count(c_np) as n_comp_notprocessed from (select * ,
    case when processed = TRUE then 1 end as c_p ,
    case when processed = FALSE then 0 end as c_np 
    from facebook_complaints) as a
       group by type ;