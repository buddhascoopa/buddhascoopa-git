select segment_name, extents from sys.dba_segments
where segment_type='ROLLBACK' and extents > 6;
