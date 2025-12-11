module mpi_f08_functions
  use mpi, only: &
    MPIF_Abi_get_fortran_booleans => MPI_Abi_get_fortran_booleans, &
    MPIF_Abi_get_fortran_info => MPI_Abi_get_fortran_info, &
    MPIF_Abi_get_info => MPI_Abi_get_info, &
    MPIF_Abi_get_version => MPI_Abi_get_version, &
    MPIF_Abi_set_fortran_booleans => MPI_Abi_set_fortran_booleans, &
    MPIF_Abi_set_fortran_info => MPI_Abi_set_fortran_info, &
    MPIF_Abort => MPI_Abort, &
    MPIF_Accumulate => MPI_Accumulate, &
    MPIF_Accumulate_c => MPI_Accumulate_c, &
    MPIF_Add_error_class => MPI_Add_error_class, &
    MPIF_Add_error_code => MPI_Add_error_code, &
    MPIF_Add_error_string => MPI_Add_error_string, &
    MPIF_Aint_add => MPI_Aint_add, &
    MPIF_Aint_diff => MPI_Aint_diff, &
    MPIF_Allgather => MPI_Allgather, &
    MPIF_Allgather_c => MPI_Allgather_c, &
    MPIF_Allgather_init => MPI_Allgather_init, &
    MPIF_Allgather_init_c => MPI_Allgather_init_c, &
    MPIF_Allgatherv => MPI_Allgatherv, &
    MPIF_Allgatherv_c => MPI_Allgatherv_c, &
    MPIF_Allgatherv_init => MPI_Allgatherv_init, &
    MPIF_Allgatherv_init_c => MPI_Allgatherv_init_c, &
    MPIF_Alloc_mem => MPI_Alloc_mem, &
    MPIF_Allreduce => MPI_Allreduce, &
    MPIF_Allreduce_c => MPI_Allreduce_c, &
    MPIF_Allreduce_init => MPI_Allreduce_init, &
    MPIF_Allreduce_init_c => MPI_Allreduce_init_c, &
    MPIF_Alltoall => MPI_Alltoall, &
    MPIF_Alltoall_c => MPI_Alltoall_c, &
    MPIF_Alltoall_init => MPI_Alltoall_init, &
    MPIF_Alltoall_init_c => MPI_Alltoall_init_c, &
    MPIF_Alltoallv => MPI_Alltoallv, &
    MPIF_Alltoallv_c => MPI_Alltoallv_c, &
    MPIF_Alltoallv_init => MPI_Alltoallv_init, &
    MPIF_Alltoallv_init_c => MPI_Alltoallv_init_c, &
    MPIF_Alltoallw => MPI_Alltoallw, &
    MPIF_Alltoallw_c => MPI_Alltoallw_c, &
    MPIF_Alltoallw_init => MPI_Alltoallw_init, &
    MPIF_Alltoallw_init_c => MPI_Alltoallw_init_c, &
    MPIF_Attr_delete => MPI_Attr_delete, &
    MPIF_Attr_get => MPI_Attr_get, &
    MPIF_Attr_put => MPI_Attr_put, &
    MPIF_Barrier => MPI_Barrier, &
    MPIF_Barrier_init => MPI_Barrier_init, &
    MPIF_Bcast => MPI_Bcast, &
    MPIF_Bcast_c => MPI_Bcast_c, &
    MPIF_Bcast_init => MPI_Bcast_init, &
    MPIF_Bcast_init_c => MPI_Bcast_init_c, &
    MPIF_Bsend => MPI_Bsend, &
    MPIF_Bsend_c => MPI_Bsend_c, &
    MPIF_Bsend_init => MPI_Bsend_init, &
    MPIF_Bsend_init_c => MPI_Bsend_init_c, &
    MPIF_Buffer_attach => MPI_Buffer_attach, &
    MPIF_Buffer_attach_c => MPI_Buffer_attach_c, &
    MPIF_Buffer_detach => MPI_Buffer_detach, &
    MPIF_Buffer_detach_c => MPI_Buffer_detach_c, &
    MPIF_Buffer_flush => MPI_Buffer_flush, &
    MPIF_Buffer_iflush => MPI_Buffer_iflush, &
    MPIF_Cancel => MPI_Cancel, &
    MPIF_Cart_coords => MPI_Cart_coords, &
    MPIF_Cart_create => MPI_Cart_create, &
    MPIF_Cart_get => MPI_Cart_get, &
    MPIF_Cart_map => MPI_Cart_map, &
    MPIF_Cart_rank => MPI_Cart_rank, &
    MPIF_Cart_shift => MPI_Cart_shift, &
    MPIF_Cart_sub => MPI_Cart_sub, &
    MPIF_Cartdim_get => MPI_Cartdim_get, &
    MPIF_Close_port => MPI_Close_port, &
    MPIF_Comm_accept => MPI_Comm_accept, &
    MPIF_Comm_attach_buffer => MPI_Comm_attach_buffer, &
    MPIF_Comm_attach_buffer_c => MPI_Comm_attach_buffer_c, &
    MPIF_Comm_call_errhandler => MPI_Comm_call_errhandler, &
    MPIF_Comm_compare => MPI_Comm_compare, &
    MPIF_Comm_connect => MPI_Comm_connect, &
    MPIF_Comm_create => MPI_Comm_create, &
    MPIF_Comm_create_errhandler => MPI_Comm_create_errhandler, &
    MPIF_Comm_create_from_group => MPI_Comm_create_from_group, &
    MPIF_Comm_create_group => MPI_Comm_create_group, &
    MPIF_Comm_create_keyval => MPI_Comm_create_keyval, &
    MPIF_Comm_delete_attr => MPI_Comm_delete_attr, &
    MPIF_Comm_detach_buffer => MPI_Comm_detach_buffer, &
    MPIF_Comm_detach_buffer_c => MPI_Comm_detach_buffer_c, &
    MPIF_Comm_disconnect => MPI_Comm_disconnect, &
    MPIF_Comm_dup => MPI_Comm_dup, &
    MPIF_Comm_dup_with_info => MPI_Comm_dup_with_info, &
    MPIF_Comm_flush_buffer => MPI_Comm_flush_buffer, &
    MPIF_Comm_free => MPI_Comm_free, &
    MPIF_Comm_free_keyval => MPI_Comm_free_keyval, &
    MPIF_Comm_get_attr => MPI_Comm_get_attr, &
    MPIF_Comm_get_errhandler => MPI_Comm_get_errhandler, &
    MPIF_Comm_get_info => MPI_Comm_get_info, &
    MPIF_Comm_get_name => MPI_Comm_get_name, &
    MPIF_Comm_get_parent => MPI_Comm_get_parent, &
    MPIF_Comm_group => MPI_Comm_group, &
    MPIF_Comm_idup => MPI_Comm_idup, &
    MPIF_Comm_idup_with_info => MPI_Comm_idup_with_info, &
    MPIF_Comm_iflush_buffer => MPI_Comm_iflush_buffer, &
    MPIF_Comm_join => MPI_Comm_join, &
    MPIF_Comm_rank => MPI_Comm_rank, &
    MPIF_Comm_remote_group => MPI_Comm_remote_group, &
    MPIF_Comm_remote_size => MPI_Comm_remote_size, &
    MPIF_Comm_set_attr => MPI_Comm_set_attr, &
    MPIF_Comm_set_errhandler => MPI_Comm_set_errhandler, &
    MPIF_Comm_set_info => MPI_Comm_set_info, &
    MPIF_Comm_set_name => MPI_Comm_set_name, &
    MPIF_Comm_size => MPI_Comm_size, &
    MPIF_Comm_spawn => MPI_Comm_spawn, &
    MPIF_Comm_spawn_multiple => MPI_Comm_spawn_multiple, &
    MPIF_Comm_split => MPI_Comm_split, &
    MPIF_Comm_split_type => MPI_Comm_split_type, &
    MPIF_Comm_test_inter => MPI_Comm_test_inter, &
    MPIF_Compare_and_swap => MPI_Compare_and_swap, &
    MPIF_Dims_create => MPI_Dims_create, &
    MPIF_Dist_graph_create => MPI_Dist_graph_create, &
    MPIF_Dist_graph_create_adjacent => MPI_Dist_graph_create_adjacent, &
    MPIF_Dist_graph_neighbors => MPI_Dist_graph_neighbors, &
    MPIF_Dist_graph_neighbors_count => MPI_Dist_graph_neighbors_count, &
    MPIF_Errhandler_free => MPI_Errhandler_free, &
    MPIF_Error_class => MPI_Error_class, &
    MPIF_Error_string => MPI_Error_string, &
    MPIF_Exscan => MPI_Exscan, &
    MPIF_Exscan_c => MPI_Exscan_c, &
    MPIF_Exscan_init => MPI_Exscan_init, &
    MPIF_Exscan_init_c => MPI_Exscan_init_c, &
    MPIF_F_sync_reg => MPI_F_sync_reg, &
    MPIF_Fetch_and_op => MPI_Fetch_and_op, &
    MPIF_File_call_errhandler => MPI_File_call_errhandler, &
    MPIF_File_close => MPI_File_close, &
    MPIF_File_create_errhandler => MPI_File_create_errhandler, &
    MPIF_File_delete => MPI_File_delete, &
    MPIF_File_get_amode => MPI_File_get_amode, &
    MPIF_File_get_atomicity => MPI_File_get_atomicity, &
    MPIF_File_get_byte_offset => MPI_File_get_byte_offset, &
    MPIF_File_get_errhandler => MPI_File_get_errhandler, &
    MPIF_File_get_group => MPI_File_get_group, &
    MPIF_File_get_info => MPI_File_get_info, &
    MPIF_File_get_position => MPI_File_get_position, &
    MPIF_File_get_position_shared => MPI_File_get_position_shared, &
    MPIF_File_get_size => MPI_File_get_size, &
    MPIF_File_get_type_extent => MPI_File_get_type_extent, &
    MPIF_File_get_type_extent_c => MPI_File_get_type_extent_c, &
    MPIF_File_get_view => MPI_File_get_view, &
    MPIF_File_iread => MPI_File_iread, &
    MPIF_File_iread_c => MPI_File_iread_c, &
    MPIF_File_iread_all => MPI_File_iread_all, &
    MPIF_File_iread_all_c => MPI_File_iread_all_c, &
    MPIF_File_iread_at => MPI_File_iread_at, &
    MPIF_File_iread_at_c => MPI_File_iread_at_c, &
    MPIF_File_iread_at_all => MPI_File_iread_at_all, &
    MPIF_File_iread_at_all_c => MPI_File_iread_at_all_c, &
    MPIF_File_iread_shared => MPI_File_iread_shared, &
    MPIF_File_iread_shared_c => MPI_File_iread_shared_c, &
    MPIF_File_iwrite => MPI_File_iwrite, &
    MPIF_File_iwrite_c => MPI_File_iwrite_c, &
    MPIF_File_iwrite_all => MPI_File_iwrite_all, &
    MPIF_File_iwrite_all_c => MPI_File_iwrite_all_c, &
    MPIF_File_iwrite_at => MPI_File_iwrite_at, &
    MPIF_File_iwrite_at_c => MPI_File_iwrite_at_c, &
    MPIF_File_iwrite_at_all => MPI_File_iwrite_at_all, &
    MPIF_File_iwrite_at_all_c => MPI_File_iwrite_at_all_c, &
    MPIF_File_iwrite_shared => MPI_File_iwrite_shared, &
    MPIF_File_iwrite_shared_c => MPI_File_iwrite_shared_c, &
    MPIF_File_open => MPI_File_open, &
    MPIF_File_preallocate => MPI_File_preallocate, &
    MPIF_File_read => MPI_File_read, &
    MPIF_File_read_c => MPI_File_read_c, &
    MPIF_File_read_all => MPI_File_read_all, &
    MPIF_File_read_all_c => MPI_File_read_all_c, &
    MPIF_File_read_all_begin => MPI_File_read_all_begin, &
    MPIF_File_read_all_begin_c => MPI_File_read_all_begin_c, &
    MPIF_File_read_all_end => MPI_File_read_all_end, &
    MPIF_File_read_at => MPI_File_read_at, &
    MPIF_File_read_at_c => MPI_File_read_at_c, &
    MPIF_File_read_at_all => MPI_File_read_at_all, &
    MPIF_File_read_at_all_c => MPI_File_read_at_all_c, &
    MPIF_File_read_at_all_begin => MPI_File_read_at_all_begin, &
    MPIF_File_read_at_all_begin_c => MPI_File_read_at_all_begin_c, &
    MPIF_File_read_at_all_end => MPI_File_read_at_all_end, &
    MPIF_File_read_ordered => MPI_File_read_ordered, &
    MPIF_File_read_ordered_c => MPI_File_read_ordered_c, &
    MPIF_File_read_ordered_begin => MPI_File_read_ordered_begin, &
    MPIF_File_read_ordered_begin_c => MPI_File_read_ordered_begin_c, &
    MPIF_File_read_ordered_end => MPI_File_read_ordered_end, &
    MPIF_File_read_shared => MPI_File_read_shared, &
    MPIF_File_read_shared_c => MPI_File_read_shared_c, &
    MPIF_File_seek => MPI_File_seek, &
    MPIF_File_seek_shared => MPI_File_seek_shared, &
    MPIF_File_set_atomicity => MPI_File_set_atomicity, &
    MPIF_File_set_errhandler => MPI_File_set_errhandler, &
    MPIF_File_set_info => MPI_File_set_info, &
    MPIF_File_set_size => MPI_File_set_size, &
    MPIF_File_set_view => MPI_File_set_view, &
    MPIF_File_sync => MPI_File_sync, &
    MPIF_File_write => MPI_File_write, &
    MPIF_File_write_c => MPI_File_write_c, &
    MPIF_File_write_all => MPI_File_write_all, &
    MPIF_File_write_all_c => MPI_File_write_all_c, &
    MPIF_File_write_all_begin => MPI_File_write_all_begin, &
    MPIF_File_write_all_begin_c => MPI_File_write_all_begin_c, &
    MPIF_File_write_all_end => MPI_File_write_all_end, &
    MPIF_File_write_at => MPI_File_write_at, &
    MPIF_File_write_at_c => MPI_File_write_at_c, &
    MPIF_File_write_at_all => MPI_File_write_at_all, &
    MPIF_File_write_at_all_c => MPI_File_write_at_all_c, &
    MPIF_File_write_at_all_begin => MPI_File_write_at_all_begin, &
    MPIF_File_write_at_all_begin_c => MPI_File_write_at_all_begin_c, &
    MPIF_File_write_at_all_end => MPI_File_write_at_all_end, &
    MPIF_File_write_ordered => MPI_File_write_ordered, &
    MPIF_File_write_ordered_c => MPI_File_write_ordered_c, &
    MPIF_File_write_ordered_begin => MPI_File_write_ordered_begin, &
    MPIF_File_write_ordered_begin_c => MPI_File_write_ordered_begin_c, &
    MPIF_File_write_ordered_end => MPI_File_write_ordered_end, &
    MPIF_File_write_shared => MPI_File_write_shared, &
    MPIF_File_write_shared_c => MPI_File_write_shared_c, &
    MPIF_Finalize => MPI_Finalize, &
    MPIF_Finalized => MPI_Finalized, &
    MPIF_Free_mem => MPI_Free_mem, &
    MPIF_Gather => MPI_Gather, &
    MPIF_Gather_c => MPI_Gather_c, &
    MPIF_Gather_init => MPI_Gather_init, &
    MPIF_Gather_init_c => MPI_Gather_init_c, &
    MPIF_Gatherv => MPI_Gatherv, &
    MPIF_Gatherv_c => MPI_Gatherv_c, &
    MPIF_Gatherv_init => MPI_Gatherv_init, &
    MPIF_Gatherv_init_c => MPI_Gatherv_init_c, &
    MPIF_Get => MPI_Get, &
    MPIF_Get_c => MPI_Get_c, &
    MPIF_Get_accumulate => MPI_Get_accumulate, &
    MPIF_Get_accumulate_c => MPI_Get_accumulate_c, &
    MPIF_Get_address => MPI_Get_address, &
    MPIF_Get_count => MPI_Get_count, &
    MPIF_Get_count_c => MPI_Get_count_c, &
    MPIF_Get_elements => MPI_Get_elements, &
    MPIF_Get_elements_c => MPI_Get_elements_c, &
    MPIF_Get_elements_x => MPI_Get_elements_x, &
    MPIF_Get_hw_resource_info => MPI_Get_hw_resource_info, &
    MPIF_Get_library_version => MPI_Get_library_version, &
    MPIF_Get_processor_name => MPI_Get_processor_name, &
    MPIF_Get_version => MPI_Get_version, &
    MPIF_Graph_create => MPI_Graph_create, &
    MPIF_Graph_get => MPI_Graph_get, &
    MPIF_Graph_map => MPI_Graph_map, &
    MPIF_Graph_neighbors => MPI_Graph_neighbors, &
    MPIF_Graph_neighbors_count => MPI_Graph_neighbors_count, &
    MPIF_Graphdims_get => MPI_Graphdims_get, &
    MPIF_Grequest_complete => MPI_Grequest_complete, &
    MPIF_Grequest_start => MPI_Grequest_start, &
    MPIF_Group_compare => MPI_Group_compare, &
    MPIF_Group_difference => MPI_Group_difference, &
    MPIF_Group_excl => MPI_Group_excl, &
    MPIF_Group_free => MPI_Group_free, &
    MPIF_Group_from_session_pset => MPI_Group_from_session_pset, &
    MPIF_Group_incl => MPI_Group_incl, &
    MPIF_Group_intersection => MPI_Group_intersection, &
    MPIF_Group_range_excl => MPI_Group_range_excl, &
    MPIF_Group_range_incl => MPI_Group_range_incl, &
    MPIF_Group_rank => MPI_Group_rank, &
    MPIF_Group_size => MPI_Group_size, &
    MPIF_Group_translate_ranks => MPI_Group_translate_ranks, &
    MPIF_Group_union => MPI_Group_union, &
    MPIF_Iallgather => MPI_Iallgather, &
    MPIF_Iallgather_c => MPI_Iallgather_c, &
    MPIF_Iallgatherv => MPI_Iallgatherv, &
    MPIF_Iallgatherv_c => MPI_Iallgatherv_c, &
    MPIF_Iallreduce => MPI_Iallreduce, &
    MPIF_Iallreduce_c => MPI_Iallreduce_c, &
    MPIF_Ialltoall => MPI_Ialltoall, &
    MPIF_Ialltoall_c => MPI_Ialltoall_c, &
    MPIF_Ialltoallv => MPI_Ialltoallv, &
    MPIF_Ialltoallv_c => MPI_Ialltoallv_c, &
    MPIF_Ialltoallw => MPI_Ialltoallw, &
    MPIF_Ialltoallw_c => MPI_Ialltoallw_c, &
    MPIF_Ibarrier => MPI_Ibarrier, &
    MPIF_Ibcast => MPI_Ibcast, &
    MPIF_Ibcast_c => MPI_Ibcast_c, &
    MPIF_Ibsend => MPI_Ibsend, &
    MPIF_Ibsend_c => MPI_Ibsend_c, &
    MPIF_Iexscan => MPI_Iexscan, &
    MPIF_Iexscan_c => MPI_Iexscan_c, &
    MPIF_Igather => MPI_Igather, &
    MPIF_Igather_c => MPI_Igather_c, &
    MPIF_Igatherv => MPI_Igatherv, &
    MPIF_Igatherv_c => MPI_Igatherv_c, &
    MPIF_Improbe => MPI_Improbe, &
    MPIF_Imrecv => MPI_Imrecv, &
    MPIF_Imrecv_c => MPI_Imrecv_c, &
    MPIF_Ineighbor_allgather => MPI_Ineighbor_allgather, &
    MPIF_Ineighbor_allgather_c => MPI_Ineighbor_allgather_c, &
    MPIF_Ineighbor_allgatherv => MPI_Ineighbor_allgatherv, &
    MPIF_Ineighbor_allgatherv_c => MPI_Ineighbor_allgatherv_c, &
    MPIF_Ineighbor_alltoall => MPI_Ineighbor_alltoall, &
    MPIF_Ineighbor_alltoall_c => MPI_Ineighbor_alltoall_c, &
    MPIF_Ineighbor_alltoallv => MPI_Ineighbor_alltoallv, &
    MPIF_Ineighbor_alltoallv_c => MPI_Ineighbor_alltoallv_c, &
    MPIF_Ineighbor_alltoallw => MPI_Ineighbor_alltoallw, &
    MPIF_Ineighbor_alltoallw_c => MPI_Ineighbor_alltoallw_c, &
    MPIF_Info_create => MPI_Info_create, &
    MPIF_Info_create_env => MPI_Info_create_env, &
    MPIF_Info_delete => MPI_Info_delete, &
    MPIF_Info_dup => MPI_Info_dup, &
    MPIF_Info_free => MPI_Info_free, &
    MPIF_Info_get => MPI_Info_get, &
    MPIF_Info_get_nkeys => MPI_Info_get_nkeys, &
    MPIF_Info_get_nthkey => MPI_Info_get_nthkey, &
    MPIF_Info_get_string => MPI_Info_get_string, &
    MPIF_Info_get_valuelen => MPI_Info_get_valuelen, &
    MPIF_Info_set => MPI_Info_set, &
    MPIF_Init => MPI_Init, &
    MPIF_Init_thread => MPI_Init_thread, &
    MPIF_Initialized => MPI_Initialized, &
    MPIF_Intercomm_create => MPI_Intercomm_create, &
    MPIF_Intercomm_create_from_groups => MPI_Intercomm_create_from_groups, &
    MPIF_Intercomm_merge => MPI_Intercomm_merge, &
    MPIF_Iprobe => MPI_Iprobe, &
    MPIF_Irecv => MPI_Irecv, &
    MPIF_Irecv_c => MPI_Irecv_c, &
    MPIF_Ireduce => MPI_Ireduce, &
    MPIF_Ireduce_c => MPI_Ireduce_c, &
    MPIF_Ireduce_scatter => MPI_Ireduce_scatter, &
    MPIF_Ireduce_scatter_c => MPI_Ireduce_scatter_c, &
    MPIF_Ireduce_scatter_block => MPI_Ireduce_scatter_block, &
    MPIF_Ireduce_scatter_block_c => MPI_Ireduce_scatter_block_c, &
    MPIF_Irsend => MPI_Irsend, &
    MPIF_Irsend_c => MPI_Irsend_c, &
    MPIF_Is_thread_main => MPI_Is_thread_main, &
    MPIF_Iscan => MPI_Iscan, &
    MPIF_Iscan_c => MPI_Iscan_c, &
    MPIF_Iscatter => MPI_Iscatter, &
    MPIF_Iscatter_c => MPI_Iscatter_c, &
    MPIF_Iscatterv => MPI_Iscatterv, &
    MPIF_Iscatterv_c => MPI_Iscatterv_c, &
    MPIF_Isend => MPI_Isend, &
    MPIF_Isend_c => MPI_Isend_c, &
    MPIF_Isendrecv => MPI_Isendrecv, &
    MPIF_Isendrecv_c => MPI_Isendrecv_c, &
    MPIF_Isendrecv_replace => MPI_Isendrecv_replace, &
    MPIF_Isendrecv_replace_c => MPI_Isendrecv_replace_c, &
    MPIF_Issend => MPI_Issend, &
    MPIF_Issend_c => MPI_Issend_c, &
    MPIF_Keyval_create => MPI_Keyval_create, &
    MPIF_Keyval_free => MPI_Keyval_free, &
    MPIF_Lookup_name => MPI_Lookup_name, &
    MPIF_Mprobe => MPI_Mprobe, &
    MPIF_Mrecv => MPI_Mrecv, &
    MPIF_Mrecv_c => MPI_Mrecv_c, &
    MPIF_Neighbor_allgather => MPI_Neighbor_allgather, &
    MPIF_Neighbor_allgather_c => MPI_Neighbor_allgather_c, &
    MPIF_Neighbor_allgather_init => MPI_Neighbor_allgather_init, &
    MPIF_Neighbor_allgather_init_c => MPI_Neighbor_allgather_init_c, &
    MPIF_Neighbor_allgatherv => MPI_Neighbor_allgatherv, &
    MPIF_Neighbor_allgatherv_c => MPI_Neighbor_allgatherv_c, &
    MPIF_Neighbor_allgatherv_init => MPI_Neighbor_allgatherv_init, &
    MPIF_Neighbor_allgatherv_init_c => MPI_Neighbor_allgatherv_init_c, &
    MPIF_Neighbor_alltoall => MPI_Neighbor_alltoall, &
    MPIF_Neighbor_alltoall_c => MPI_Neighbor_alltoall_c, &
    MPIF_Neighbor_alltoall_init => MPI_Neighbor_alltoall_init, &
    MPIF_Neighbor_alltoall_init_c => MPI_Neighbor_alltoall_init_c, &
    MPIF_Neighbor_alltoallv => MPI_Neighbor_alltoallv, &
    MPIF_Neighbor_alltoallv_c => MPI_Neighbor_alltoallv_c, &
    MPIF_Neighbor_alltoallv_init => MPI_Neighbor_alltoallv_init, &
    MPIF_Neighbor_alltoallv_init_c => MPI_Neighbor_alltoallv_init_c, &
    MPIF_Neighbor_alltoallw => MPI_Neighbor_alltoallw, &
    MPIF_Neighbor_alltoallw_c => MPI_Neighbor_alltoallw_c, &
    MPIF_Neighbor_alltoallw_init => MPI_Neighbor_alltoallw_init, &
    MPIF_Neighbor_alltoallw_init_c => MPI_Neighbor_alltoallw_init_c, &
    MPIF_Op_commutative => MPI_Op_commutative, &
    MPIF_Op_create => MPI_Op_create, &
    MPIF_Op_create_c => MPI_Op_create_c, &
    MPIF_Op_free => MPI_Op_free, &
    MPIF_Open_port => MPI_Open_port, &
    MPIF_Pack => MPI_Pack, &
    MPIF_Pack_c => MPI_Pack_c, &
    MPIF_Pack_external => MPI_Pack_external, &
    MPIF_Pack_external_c => MPI_Pack_external_c, &
    MPIF_Pack_external_size => MPI_Pack_external_size, &
    MPIF_Pack_external_size_c => MPI_Pack_external_size_c, &
    MPIF_Pack_size => MPI_Pack_size, &
    MPIF_Pack_size_c => MPI_Pack_size_c, &
    MPIF_Parrived => MPI_Parrived, &
    MPIF_Pready => MPI_Pready, &
    MPIF_Pready_list => MPI_Pready_list, &
    MPIF_Pready_range => MPI_Pready_range, &
    MPIF_Precv_init => MPI_Precv_init, &
    MPIF_Probe => MPI_Probe, &
    MPIF_Psend_init => MPI_Psend_init, &
    MPIF_Publish_name => MPI_Publish_name, &
    MPIF_Put => MPI_Put, &
    MPIF_Put_c => MPI_Put_c, &
    MPIF_Query_thread => MPI_Query_thread, &
    MPIF_Raccumulate => MPI_Raccumulate, &
    MPIF_Raccumulate_c => MPI_Raccumulate_c, &
    MPIF_Recv => MPI_Recv, &
    MPIF_Recv_c => MPI_Recv_c, &
    MPIF_Recv_init => MPI_Recv_init, &
    MPIF_Recv_init_c => MPI_Recv_init_c, &
    MPIF_Reduce => MPI_Reduce, &
    MPIF_Reduce_c => MPI_Reduce_c, &
    MPIF_Reduce_init => MPI_Reduce_init, &
    MPIF_Reduce_init_c => MPI_Reduce_init_c, &
    MPIF_Reduce_local => MPI_Reduce_local, &
    MPIF_Reduce_local_c => MPI_Reduce_local_c, &
    MPIF_Reduce_scatter => MPI_Reduce_scatter, &
    MPIF_Reduce_scatter_c => MPI_Reduce_scatter_c, &
    MPIF_Reduce_scatter_block => MPI_Reduce_scatter_block, &
    MPIF_Reduce_scatter_block_c => MPI_Reduce_scatter_block_c, &
    MPIF_Reduce_scatter_block_init => MPI_Reduce_scatter_block_init, &
    MPIF_Reduce_scatter_block_init_c => MPI_Reduce_scatter_block_init_c, &
    MPIF_Reduce_scatter_init => MPI_Reduce_scatter_init, &
    MPIF_Reduce_scatter_init_c => MPI_Reduce_scatter_init_c, &
    MPIF_Register_datarep => MPI_Register_datarep, &
    MPIF_Register_datarep_c => MPI_Register_datarep_c, &
    MPIF_Remove_error_class => MPI_Remove_error_class, &
    MPIF_Remove_error_code => MPI_Remove_error_code, &
    MPIF_Remove_error_string => MPI_Remove_error_string, &
    MPIF_Request_free => MPI_Request_free, &
    MPIF_Request_get_status => MPI_Request_get_status, &
    MPIF_Request_get_status_all => MPI_Request_get_status_all, &
    MPIF_Request_get_status_any => MPI_Request_get_status_any, &
    MPIF_Request_get_status_some => MPI_Request_get_status_some, &
    MPIF_Rget => MPI_Rget, &
    MPIF_Rget_c => MPI_Rget_c, &
    MPIF_Rget_accumulate => MPI_Rget_accumulate, &
    MPIF_Rget_accumulate_c => MPI_Rget_accumulate_c, &
    MPIF_Rput => MPI_Rput, &
    MPIF_Rput_c => MPI_Rput_c, &
    MPIF_Rsend => MPI_Rsend, &
    MPIF_Rsend_c => MPI_Rsend_c, &
    MPIF_Rsend_init => MPI_Rsend_init, &
    MPIF_Rsend_init_c => MPI_Rsend_init_c, &
    MPIF_Scan => MPI_Scan, &
    MPIF_Scan_c => MPI_Scan_c, &
    MPIF_Scan_init => MPI_Scan_init, &
    MPIF_Scan_init_c => MPI_Scan_init_c, &
    MPIF_Scatter => MPI_Scatter, &
    MPIF_Scatter_c => MPI_Scatter_c, &
    MPIF_Scatter_init => MPI_Scatter_init, &
    MPIF_Scatter_init_c => MPI_Scatter_init_c, &
    MPIF_Scatterv => MPI_Scatterv, &
    MPIF_Scatterv_c => MPI_Scatterv_c, &
    MPIF_Scatterv_init => MPI_Scatterv_init, &
    MPIF_Scatterv_init_c => MPI_Scatterv_init_c, &
    MPIF_Send => MPI_Send, &
    MPIF_Send_c => MPI_Send_c, &
    MPIF_Send_init => MPI_Send_init, &
    MPIF_Send_init_c => MPI_Send_init_c, &
    MPIF_Sendrecv => MPI_Sendrecv, &
    MPIF_Sendrecv_c => MPI_Sendrecv_c, &
    MPIF_Sendrecv_replace => MPI_Sendrecv_replace, &
    MPIF_Sendrecv_replace_c => MPI_Sendrecv_replace_c, &
    MPIF_Session_attach_buffer => MPI_Session_attach_buffer, &
    MPIF_Session_attach_buffer_c => MPI_Session_attach_buffer_c, &
    MPIF_Session_call_errhandler => MPI_Session_call_errhandler, &
    MPIF_Session_create_errhandler => MPI_Session_create_errhandler, &
    MPIF_Session_detach_buffer => MPI_Session_detach_buffer, &
    MPIF_Session_detach_buffer_c => MPI_Session_detach_buffer_c, &
    MPIF_Session_finalize => MPI_Session_finalize, &
    MPIF_Session_flush_buffer => MPI_Session_flush_buffer, &
    MPIF_Session_get_errhandler => MPI_Session_get_errhandler, &
    MPIF_Session_get_info => MPI_Session_get_info, &
    MPIF_Session_get_nth_pset => MPI_Session_get_nth_pset, &
    MPIF_Session_get_num_psets => MPI_Session_get_num_psets, &
    MPIF_Session_get_pset_info => MPI_Session_get_pset_info, &
    MPIF_Session_iflush_buffer => MPI_Session_iflush_buffer, &
    MPIF_Session_init => MPI_Session_init, &
    MPIF_Session_set_errhandler => MPI_Session_set_errhandler, &
    MPIF_Ssend => MPI_Ssend, &
    MPIF_Ssend_c => MPI_Ssend_c, &
    MPIF_Ssend_init => MPI_Ssend_init, &
    MPIF_Ssend_init_c => MPI_Ssend_init_c, &
    MPIF_Start => MPI_Start, &
    MPIF_Startall => MPI_Startall, &
    MPIF_Status_get_error => MPI_Status_get_error, &
    MPIF_Status_get_source => MPI_Status_get_source, &
    MPIF_Status_get_tag => MPI_Status_get_tag, &
    MPIF_Status_set_cancelled => MPI_Status_set_cancelled, &
    MPIF_Status_set_elements => MPI_Status_set_elements, &
    MPIF_Status_set_elements_c => MPI_Status_set_elements_c, &
    MPIF_Status_set_elements_x => MPI_Status_set_elements_x, &
    MPIF_Status_set_error => MPI_Status_set_error, &
    MPIF_Status_set_source => MPI_Status_set_source, &
    MPIF_Status_set_tag => MPI_Status_set_tag, &
    MPIF_Test => MPI_Test, &
    MPIF_Test_cancelled => MPI_Test_cancelled, &
    MPIF_Testall => MPI_Testall, &
    MPIF_Testany => MPI_Testany, &
    MPIF_Testsome => MPI_Testsome, &
    MPIF_Topo_test => MPI_Topo_test, &
    MPIF_Type_commit => MPI_Type_commit, &
    MPIF_Type_contiguous => MPI_Type_contiguous, &
    MPIF_Type_contiguous_c => MPI_Type_contiguous_c, &
    MPIF_Type_create_darray => MPI_Type_create_darray, &
    MPIF_Type_create_darray_c => MPI_Type_create_darray_c, &
    MPIF_Type_create_f90_complex => MPI_Type_create_f90_complex, &
    MPIF_Type_create_f90_integer => MPI_Type_create_f90_integer, &
    MPIF_Type_create_f90_real => MPI_Type_create_f90_real, &
    MPIF_Type_create_hindexed => MPI_Type_create_hindexed, &
    MPIF_Type_create_hindexed_c => MPI_Type_create_hindexed_c, &
    MPIF_Type_create_hindexed_block => MPI_Type_create_hindexed_block, &
    MPIF_Type_create_hindexed_block_c => MPI_Type_create_hindexed_block_c, &
    MPIF_Type_create_hvector => MPI_Type_create_hvector, &
    MPIF_Type_create_hvector_c => MPI_Type_create_hvector_c, &
    MPIF_Type_create_indexed_block => MPI_Type_create_indexed_block, &
    MPIF_Type_create_indexed_block_c => MPI_Type_create_indexed_block_c, &
    MPIF_Type_create_keyval => MPI_Type_create_keyval, &
    MPIF_Type_create_resized => MPI_Type_create_resized, &
    MPIF_Type_create_resized_c => MPI_Type_create_resized_c, &
    MPIF_Type_create_struct => MPI_Type_create_struct, &
    MPIF_Type_create_struct_c => MPI_Type_create_struct_c, &
    MPIF_Type_create_subarray => MPI_Type_create_subarray, &
    MPIF_Type_create_subarray_c => MPI_Type_create_subarray_c, &
    MPIF_Type_delete_attr => MPI_Type_delete_attr, &
    MPIF_Type_dup => MPI_Type_dup, &
    MPIF_Type_free => MPI_Type_free, &
    MPIF_Type_free_keyval => MPI_Type_free_keyval, &
    MPIF_Type_get_attr => MPI_Type_get_attr, &
    MPIF_Type_get_contents => MPI_Type_get_contents, &
    MPIF_Type_get_contents_c => MPI_Type_get_contents_c, &
    MPIF_Type_get_envelope => MPI_Type_get_envelope, &
    MPIF_Type_get_envelope_c => MPI_Type_get_envelope_c, &
    MPIF_Type_get_extent => MPI_Type_get_extent, &
    MPIF_Type_get_extent_c => MPI_Type_get_extent_c, &
    MPIF_Type_get_extent_x => MPI_Type_get_extent_x, &
    MPIF_Type_get_name => MPI_Type_get_name, &
    MPIF_Type_get_true_extent => MPI_Type_get_true_extent, &
    MPIF_Type_get_true_extent_c => MPI_Type_get_true_extent_c, &
    MPIF_Type_get_true_extent_x => MPI_Type_get_true_extent_x, &
    MPIF_Type_get_value_index => MPI_Type_get_value_index, &
    MPIF_Type_indexed => MPI_Type_indexed, &
    MPIF_Type_indexed_c => MPI_Type_indexed_c, &
    MPIF_Type_match_size => MPI_Type_match_size, &
    MPIF_Type_set_attr => MPI_Type_set_attr, &
    MPIF_Type_set_name => MPI_Type_set_name, &
    MPIF_Type_size => MPI_Type_size, &
    MPIF_Type_size_c => MPI_Type_size_c, &
    MPIF_Type_size_x => MPI_Type_size_x, &
    MPIF_Type_vector => MPI_Type_vector, &
    MPIF_Type_vector_c => MPI_Type_vector_c, &
    MPIF_Unpack => MPI_Unpack, &
    MPIF_Unpack_c => MPI_Unpack_c, &
    MPIF_Unpack_external => MPI_Unpack_external, &
    MPIF_Unpack_external_c => MPI_Unpack_external_c, &
    MPIF_Unpublish_name => MPI_Unpublish_name, &
    MPIF_Wait => MPI_Wait, &
    MPIF_Waitall => MPI_Waitall, &
    MPIF_Waitany => MPI_Waitany, &
    MPIF_Waitsome => MPI_Waitsome, &
    MPIF_Win_allocate => MPI_Win_allocate, &
    MPIF_Win_allocate_c => MPI_Win_allocate_c, &
    MPIF_Win_allocate_shared => MPI_Win_allocate_shared, &
    MPIF_Win_allocate_shared_c => MPI_Win_allocate_shared_c, &
    MPIF_Win_attach => MPI_Win_attach, &
    MPIF_Win_call_errhandler => MPI_Win_call_errhandler, &
    MPIF_Win_complete => MPI_Win_complete, &
    MPIF_Win_create => MPI_Win_create, &
    MPIF_Win_create_c => MPI_Win_create_c, &
    MPIF_Win_create_dynamic => MPI_Win_create_dynamic, &
    MPIF_Win_create_errhandler => MPI_Win_create_errhandler, &
    MPIF_Win_create_keyval => MPI_Win_create_keyval, &
    MPIF_Win_delete_attr => MPI_Win_delete_attr, &
    MPIF_Win_detach => MPI_Win_detach, &
    MPIF_Win_fence => MPI_Win_fence, &
    MPIF_Win_flush => MPI_Win_flush, &
    MPIF_Win_flush_all => MPI_Win_flush_all, &
    MPIF_Win_flush_local => MPI_Win_flush_local, &
    MPIF_Win_flush_local_all => MPI_Win_flush_local_all, &
    MPIF_Win_free => MPI_Win_free, &
    MPIF_Win_free_keyval => MPI_Win_free_keyval, &
    MPIF_Win_get_attr => MPI_Win_get_attr, &
    MPIF_Win_get_errhandler => MPI_Win_get_errhandler, &
    MPIF_Win_get_group => MPI_Win_get_group, &
    MPIF_Win_get_info => MPI_Win_get_info, &
    MPIF_Win_get_name => MPI_Win_get_name, &
    MPIF_Win_lock => MPI_Win_lock, &
    MPIF_Win_lock_all => MPI_Win_lock_all, &
    MPIF_Win_post => MPI_Win_post, &
    MPIF_Win_set_attr => MPI_Win_set_attr, &
    MPIF_Win_set_errhandler => MPI_Win_set_errhandler, &
    MPIF_Win_set_info => MPI_Win_set_info, &
    MPIF_Win_set_name => MPI_Win_set_name, &
    MPIF_Win_shared_query => MPI_Win_shared_query, &
    MPIF_Win_shared_query_c => MPI_Win_shared_query_c, &
    MPIF_Win_start => MPI_Win_start, &
    MPIF_Win_sync => MPI_Win_sync, &
    MPIF_Win_test => MPI_Win_test, &
    MPIF_Win_unlock => MPI_Win_unlock, &
    MPIF_Win_unlock_all => MPI_Win_unlock_all, &
    MPIF_Win_wait => MPI_Win_wait, &
    MPIF_Wtick => MPI_Wtick, &
    MPIF_Wtime => MPI_Wtime, &
    MPI_VERSION
  implicit none
  private
  save

  public :: MPI_Abi_get_fortran_booleans
  public :: MPI_Abi_get_fortran_info
  public :: MPI_Abi_get_info
  public :: MPI_Abi_get_version
  public :: MPI_Abi_set_fortran_booleans
  public :: MPI_Abi_set_fortran_info
  public :: MPI_Abort
  public :: MPI_Accumulate
  public :: MPI_Accumulate_c
  public :: MPI_Add_error_class
  public :: MPI_Add_error_code
  public :: MPI_Add_error_string
  public :: MPI_Aint_add
  public :: MPI_Aint_diff
  public :: MPI_Allgather
  public :: MPI_Allgather_c
  public :: MPI_Allgather_init
  public :: MPI_Allgather_init_c
  public :: MPI_Allgatherv
  public :: MPI_Allgatherv_c
  public :: MPI_Allgatherv_init
  public :: MPI_Allgatherv_init_c
  public :: MPI_Alloc_mem
  public :: MPI_Allreduce
  public :: MPI_Allreduce_c
  public :: MPI_Allreduce_init
  public :: MPI_Allreduce_init_c
  public :: MPI_Alltoall
  public :: MPI_Alltoall_c
  public :: MPI_Alltoall_init
  public :: MPI_Alltoall_init_c
  public :: MPI_Alltoallv
  public :: MPI_Alltoallv_c
  public :: MPI_Alltoallv_init
  public :: MPI_Alltoallv_init_c
  public :: MPI_Alltoallw
  public :: MPI_Alltoallw_c
  public :: MPI_Alltoallw_init
  public :: MPI_Alltoallw_init_c
  public :: MPI_Attr_delete
  public :: MPI_Attr_get
  public :: MPI_Attr_put
  public :: MPI_Barrier
  public :: MPI_Barrier_init
  public :: MPI_Bcast
  public :: MPI_Bcast_c
  public :: MPI_Bcast_init
  public :: MPI_Bcast_init_c
  public :: MPI_Bsend
  public :: MPI_Bsend_c
  public :: MPI_Bsend_init
  public :: MPI_Bsend_init_c
  public :: MPI_Buffer_attach
  public :: MPI_Buffer_attach_c
  public :: MPI_Buffer_detach
  public :: MPI_Buffer_detach_c
  public :: MPI_Buffer_flush
  public :: MPI_Buffer_iflush
  public :: MPI_Cancel
  public :: MPI_Cart_coords
  public :: MPI_Cart_create
  public :: MPI_Cart_get
  public :: MPI_Cart_map
  public :: MPI_Cart_rank
  public :: MPI_Cart_shift
  public :: MPI_Cart_sub
  public :: MPI_Cartdim_get
  public :: MPI_Close_port
  public :: MPI_Comm_accept
  public :: MPI_Comm_attach_buffer
  public :: MPI_Comm_attach_buffer_c
  public :: MPI_Comm_call_errhandler
  public :: MPI_Comm_compare
  public :: MPI_Comm_connect
  public :: MPI_Comm_create
  public :: MPI_Comm_create_errhandler
  public :: MPI_Comm_create_from_group
  public :: MPI_Comm_create_group
  public :: MPI_Comm_create_keyval
  public :: MPI_Comm_delete_attr
  public :: MPI_Comm_detach_buffer
  public :: MPI_Comm_detach_buffer_c
  public :: MPI_Comm_disconnect
  public :: MPI_Comm_dup
  public :: MPI_Comm_dup_with_info
  public :: MPI_Comm_flush_buffer
  public :: MPI_Comm_free
  public :: MPI_Comm_free_keyval
  public :: MPI_Comm_get_attr
  public :: MPI_Comm_get_errhandler
  public :: MPI_Comm_get_info
  public :: MPI_Comm_get_name
  public :: MPI_Comm_get_parent
  public :: MPI_Comm_group
  public :: MPI_Comm_idup
  public :: MPI_Comm_idup_with_info
  public :: MPI_Comm_iflush_buffer
  public :: MPI_Comm_join
  public :: MPI_Comm_rank
  public :: MPI_Comm_remote_group
  public :: MPI_Comm_remote_size
  public :: MPI_Comm_set_attr
  public :: MPI_Comm_set_errhandler
  public :: MPI_Comm_set_info
  public :: MPI_Comm_set_name
  public :: MPI_Comm_size
  public :: MPI_Comm_spawn
  public :: MPI_Comm_spawn_multiple
  public :: MPI_Comm_split
  public :: MPI_Comm_split_type
  public :: MPI_Comm_test_inter
  public :: MPI_Compare_and_swap
  public :: MPI_Dims_create
  public :: MPI_Dist_graph_create
  public :: MPI_Dist_graph_create_adjacent
  public :: MPI_Dist_graph_neighbors
  public :: MPI_Dist_graph_neighbors_count
  public :: MPI_Errhandler_free
  public :: MPI_Error_class
  public :: MPI_Error_string
  public :: MPI_Exscan
  public :: MPI_Exscan_c
  public :: MPI_Exscan_init
  public :: MPI_Exscan_init_c
  public :: MPI_F_sync_reg
  public :: MPI_Fetch_and_op
  public :: MPI_File_call_errhandler
  public :: MPI_File_close
  public :: MPI_File_create_errhandler
  public :: MPI_File_delete
  public :: MPI_File_get_amode
  public :: MPI_File_get_atomicity
  public :: MPI_File_get_byte_offset
  public :: MPI_File_get_errhandler
  public :: MPI_File_get_group
  public :: MPI_File_get_info
  public :: MPI_File_get_position
  public :: MPI_File_get_position_shared
  public :: MPI_File_get_size
  public :: MPI_File_get_type_extent
  public :: MPI_File_get_type_extent_c
  public :: MPI_File_get_view
  public :: MPI_File_iread
  public :: MPI_File_iread_c
  public :: MPI_File_iread_all
  public :: MPI_File_iread_all_c
  public :: MPI_File_iread_at
  public :: MPI_File_iread_at_c
  public :: MPI_File_iread_at_all
  public :: MPI_File_iread_at_all_c
  public :: MPI_File_iread_shared
  public :: MPI_File_iread_shared_c
  public :: MPI_File_iwrite
  public :: MPI_File_iwrite_c
  public :: MPI_File_iwrite_all
  public :: MPI_File_iwrite_all_c
  public :: MPI_File_iwrite_at
  public :: MPI_File_iwrite_at_c
  public :: MPI_File_iwrite_at_all
  public :: MPI_File_iwrite_at_all_c
  public :: MPI_File_iwrite_shared
  public :: MPI_File_iwrite_shared_c
  public :: MPI_File_open
  public :: MPI_File_preallocate
  public :: MPI_File_read
  public :: MPI_File_read_c
  public :: MPI_File_read_all
  public :: MPI_File_read_all_c
  public :: MPI_File_read_all_begin
  public :: MPI_File_read_all_begin_c
  public :: MPI_File_read_all_end
  public :: MPI_File_read_at
  public :: MPI_File_read_at_c
  public :: MPI_File_read_at_all
  public :: MPI_File_read_at_all_c
  public :: MPI_File_read_at_all_begin
  public :: MPI_File_read_at_all_begin_c
  public :: MPI_File_read_at_all_end
  public :: MPI_File_read_ordered
  public :: MPI_File_read_ordered_c
  public :: MPI_File_read_ordered_begin
  public :: MPI_File_read_ordered_begin_c
  public :: MPI_File_read_ordered_end
  public :: MPI_File_read_shared
  public :: MPI_File_read_shared_c
  public :: MPI_File_seek
  public :: MPI_File_seek_shared
  public :: MPI_File_set_atomicity
  public :: MPI_File_set_errhandler
  public :: MPI_File_set_info
  public :: MPI_File_set_size
  public :: MPI_File_set_view
  public :: MPI_File_sync
  public :: MPI_File_write
  public :: MPI_File_write_c
  public :: MPI_File_write_all
  public :: MPI_File_write_all_c
  public :: MPI_File_write_all_begin
  public :: MPI_File_write_all_begin_c
  public :: MPI_File_write_all_end
  public :: MPI_File_write_at
  public :: MPI_File_write_at_c
  public :: MPI_File_write_at_all
  public :: MPI_File_write_at_all_c
  public :: MPI_File_write_at_all_begin
  public :: MPI_File_write_at_all_begin_c
  public :: MPI_File_write_at_all_end
  public :: MPI_File_write_ordered
  public :: MPI_File_write_ordered_c
  public :: MPI_File_write_ordered_begin
  public :: MPI_File_write_ordered_begin_c
  public :: MPI_File_write_ordered_end
  public :: MPI_File_write_shared
  public :: MPI_File_write_shared_c
  public :: MPI_Finalize
  public :: MPI_Finalized
  public :: MPI_Free_mem
  public :: MPI_Gather
  public :: MPI_Gather_c
  public :: MPI_Gather_init
  public :: MPI_Gather_init_c
  public :: MPI_Gatherv
  public :: MPI_Gatherv_c
  public :: MPI_Gatherv_init
  public :: MPI_Gatherv_init_c
  public :: MPI_Get
  public :: MPI_Get_c
  public :: MPI_Get_accumulate
  public :: MPI_Get_accumulate_c
  public :: MPI_Get_address
  public :: MPI_Get_count
  public :: MPI_Get_count_c
  public :: MPI_Get_elements
  public :: MPI_Get_elements_c
  public :: MPI_Get_elements_x
  public :: MPI_Get_hw_resource_info
  public :: MPI_Get_library_version
  public :: MPI_Get_processor_name
  public :: MPI_Get_version
  public :: MPI_Graph_create
  public :: MPI_Graph_get
  public :: MPI_Graph_map
  public :: MPI_Graph_neighbors
  public :: MPI_Graph_neighbors_count
  public :: MPI_Graphdims_get
  public :: MPI_Grequest_complete
  public :: MPI_Grequest_start
  public :: MPI_Group_compare
  public :: MPI_Group_difference
  public :: MPI_Group_excl
  public :: MPI_Group_free
  public :: MPI_Group_from_session_pset
  public :: MPI_Group_incl
  public :: MPI_Group_intersection
  public :: MPI_Group_range_excl
  public :: MPI_Group_range_incl
  public :: MPI_Group_rank
  public :: MPI_Group_size
  public :: MPI_Group_translate_ranks
  public :: MPI_Group_union
  public :: MPI_Iallgather
  public :: MPI_Iallgather_c
  public :: MPI_Iallgatherv
  public :: MPI_Iallgatherv_c
  public :: MPI_Iallreduce
  public :: MPI_Iallreduce_c
  public :: MPI_Ialltoall
  public :: MPI_Ialltoall_c
  public :: MPI_Ialltoallv
  public :: MPI_Ialltoallv_c
  public :: MPI_Ialltoallw
  public :: MPI_Ialltoallw_c
  public :: MPI_Ibarrier
  public :: MPI_Ibcast
  public :: MPI_Ibcast_c
  public :: MPI_Ibsend
  public :: MPI_Ibsend_c
  public :: MPI_Iexscan
  public :: MPI_Iexscan_c
  public :: MPI_Igather
  public :: MPI_Igather_c
  public :: MPI_Igatherv
  public :: MPI_Igatherv_c
  public :: MPI_Improbe
  public :: MPI_Imrecv
  public :: MPI_Imrecv_c
  public :: MPI_Ineighbor_allgather
  public :: MPI_Ineighbor_allgather_c
  public :: MPI_Ineighbor_allgatherv
  public :: MPI_Ineighbor_allgatherv_c
  public :: MPI_Ineighbor_alltoall
  public :: MPI_Ineighbor_alltoall_c
  public :: MPI_Ineighbor_alltoallv
  public :: MPI_Ineighbor_alltoallv_c
  public :: MPI_Ineighbor_alltoallw
  public :: MPI_Ineighbor_alltoallw_c
  public :: MPI_Info_create
  public :: MPI_Info_create_env
  public :: MPI_Info_delete
  public :: MPI_Info_dup
  public :: MPI_Info_free
  public :: MPI_Info_get
  public :: MPI_Info_get_nkeys
  public :: MPI_Info_get_nthkey
  public :: MPI_Info_get_string
  public :: MPI_Info_get_valuelen
  public :: MPI_Info_set
  public :: MPI_Init
  public :: MPI_Init_thread
  public :: MPI_Initialized
  public :: MPI_Intercomm_create
  public :: MPI_Intercomm_create_from_groups
  public :: MPI_Intercomm_merge
  public :: MPI_Iprobe
  public :: MPI_Irecv
  public :: MPI_Irecv_c
  public :: MPI_Ireduce
  public :: MPI_Ireduce_c
  public :: MPI_Ireduce_scatter
  public :: MPI_Ireduce_scatter_c
  public :: MPI_Ireduce_scatter_block
  public :: MPI_Ireduce_scatter_block_c
  public :: MPI_Irsend
  public :: MPI_Irsend_c
  public :: MPI_Is_thread_main
  public :: MPI_Iscan
  public :: MPI_Iscan_c
  public :: MPI_Iscatter
  public :: MPI_Iscatter_c
  public :: MPI_Iscatterv
  public :: MPI_Iscatterv_c
  public :: MPI_Isend
  public :: MPI_Isend_c
  public :: MPI_Isendrecv
  public :: MPI_Isendrecv_c
  public :: MPI_Isendrecv_replace
  public :: MPI_Isendrecv_replace_c
  public :: MPI_Issend
  public :: MPI_Issend_c
  public :: MPI_Keyval_create
  public :: MPI_Keyval_free
  public :: MPI_Lookup_name
  public :: MPI_Mprobe
  public :: MPI_Mrecv
  public :: MPI_Mrecv_c
  public :: MPI_Neighbor_allgather
  public :: MPI_Neighbor_allgather_c
  public :: MPI_Neighbor_allgather_init
  public :: MPI_Neighbor_allgather_init_c
  public :: MPI_Neighbor_allgatherv
  public :: MPI_Neighbor_allgatherv_c
  public :: MPI_Neighbor_allgatherv_init
  public :: MPI_Neighbor_allgatherv_init_c
  public :: MPI_Neighbor_alltoall
  public :: MPI_Neighbor_alltoall_c
  public :: MPI_Neighbor_alltoall_init
  public :: MPI_Neighbor_alltoall_init_c
  public :: MPI_Neighbor_alltoallv
  public :: MPI_Neighbor_alltoallv_c
  public :: MPI_Neighbor_alltoallv_init
  public :: MPI_Neighbor_alltoallv_init_c
  public :: MPI_Neighbor_alltoallw
  public :: MPI_Neighbor_alltoallw_c
  public :: MPI_Neighbor_alltoallw_init
  public :: MPI_Neighbor_alltoallw_init_c
  public :: MPI_Op_commutative
  public :: MPI_Op_create
  public :: MPI_Op_create_c
  public :: MPI_Op_free
  public :: MPI_Open_port
  public :: MPI_Pack
  public :: MPI_Pack_c
  public :: MPI_Pack_external
  public :: MPI_Pack_external_c
  public :: MPI_Pack_external_size
  public :: MPI_Pack_external_size_c
  public :: MPI_Pack_size
  public :: MPI_Pack_size_c
  public :: MPI_Parrived
  public :: MPI_Pready
  public :: MPI_Pready_list
  public :: MPI_Pready_range
  public :: MPI_Precv_init
  public :: MPI_Probe
  public :: MPI_Psend_init
  public :: MPI_Publish_name
  public :: MPI_Put
  public :: MPI_Put_c
  public :: MPI_Query_thread
  public :: MPI_Raccumulate
  public :: MPI_Raccumulate_c
  public :: MPI_Recv
  public :: MPI_Recv_c
  public :: MPI_Recv_init
  public :: MPI_Recv_init_c
  public :: MPI_Reduce
  public :: MPI_Reduce_c
  public :: MPI_Reduce_init
  public :: MPI_Reduce_init_c
  public :: MPI_Reduce_local
  public :: MPI_Reduce_local_c
  public :: MPI_Reduce_scatter
  public :: MPI_Reduce_scatter_c
  public :: MPI_Reduce_scatter_block
  public :: MPI_Reduce_scatter_block_c
  public :: MPI_Reduce_scatter_block_init
  public :: MPI_Reduce_scatter_block_init_c
  public :: MPI_Reduce_scatter_init
  public :: MPI_Reduce_scatter_init_c
  public :: MPI_Register_datarep
  public :: MPI_Register_datarep_c
  public :: MPI_Remove_error_class
  public :: MPI_Remove_error_code
  public :: MPI_Remove_error_string
  public :: MPI_Request_free
  public :: MPI_Request_get_status
  public :: MPI_Request_get_status_all
  public :: MPI_Request_get_status_any
  public :: MPI_Request_get_status_some
  public :: MPI_Rget
  public :: MPI_Rget_c
  public :: MPI_Rget_accumulate
  public :: MPI_Rget_accumulate_c
  public :: MPI_Rput
  public :: MPI_Rput_c
  public :: MPI_Rsend
  public :: MPI_Rsend_c
  public :: MPI_Rsend_init
  public :: MPI_Rsend_init_c
  public :: MPI_Scan
  public :: MPI_Scan_c
  public :: MPI_Scan_init
  public :: MPI_Scan_init_c
  public :: MPI_Scatter
  public :: MPI_Scatter_c
  public :: MPI_Scatter_init
  public :: MPI_Scatter_init_c
  public :: MPI_Scatterv
  public :: MPI_Scatterv_c
  public :: MPI_Scatterv_init
  public :: MPI_Scatterv_init_c
  public :: MPI_Send
  public :: MPI_Send_c
  public :: MPI_Send_init
  public :: MPI_Send_init_c
  public :: MPI_Sendrecv
  public :: MPI_Sendrecv_c
  public :: MPI_Sendrecv_replace
  public :: MPI_Sendrecv_replace_c
  public :: MPI_Session_attach_buffer
  public :: MPI_Session_attach_buffer_c
  public :: MPI_Session_call_errhandler
  public :: MPI_Session_create_errhandler
  public :: MPI_Session_detach_buffer
  public :: MPI_Session_detach_buffer_c
  public :: MPI_Session_finalize
  public :: MPI_Session_flush_buffer
  public :: MPI_Session_get_errhandler
  public :: MPI_Session_get_info
  public :: MPI_Session_get_nth_pset
  public :: MPI_Session_get_num_psets
  public :: MPI_Session_get_pset_info
  public :: MPI_Session_iflush_buffer
  public :: MPI_Session_init
  public :: MPI_Session_set_errhandler
  public :: MPI_Ssend
  public :: MPI_Ssend_c
  public :: MPI_Ssend_init
  public :: MPI_Ssend_init_c
  public :: MPI_Start
  public :: MPI_Startall
  public :: MPI_Status_get_error
  public :: MPI_Status_get_source
  public :: MPI_Status_get_tag
  public :: MPI_Status_set_cancelled
  public :: MPI_Status_set_elements
  public :: MPI_Status_set_elements_c
  public :: MPI_Status_set_elements_x
  public :: MPI_Status_set_error
  public :: MPI_Status_set_source
  public :: MPI_Status_set_tag
  public :: MPI_Test
  public :: MPI_Test_cancelled
  public :: MPI_Testall
  public :: MPI_Testany
  public :: MPI_Testsome
  public :: MPI_Topo_test
  public :: MPI_Type_commit
  public :: MPI_Type_contiguous
  public :: MPI_Type_contiguous_c
  public :: MPI_Type_create_darray
  public :: MPI_Type_create_darray_c
  public :: MPI_Type_create_f90_complex
  public :: MPI_Type_create_f90_integer
  public :: MPI_Type_create_f90_real
  public :: MPI_Type_create_hindexed
  public :: MPI_Type_create_hindexed_c
  public :: MPI_Type_create_hindexed_block
  public :: MPI_Type_create_hindexed_block_c
  public :: MPI_Type_create_hvector
  public :: MPI_Type_create_hvector_c
  public :: MPI_Type_create_indexed_block
  public :: MPI_Type_create_indexed_block_c
  public :: MPI_Type_create_keyval
  public :: MPI_Type_create_resized
  public :: MPI_Type_create_resized_c
  public :: MPI_Type_create_struct
  public :: MPI_Type_create_struct_c
  public :: MPI_Type_create_subarray
  public :: MPI_Type_create_subarray_c
  public :: MPI_Type_delete_attr
  public :: MPI_Type_dup
  public :: MPI_Type_free
  public :: MPI_Type_free_keyval
  public :: MPI_Type_get_attr
  public :: MPI_Type_get_contents
  public :: MPI_Type_get_contents_c
  public :: MPI_Type_get_envelope
  public :: MPI_Type_get_envelope_c
  public :: MPI_Type_get_extent
  public :: MPI_Type_get_extent_c
  public :: MPI_Type_get_extent_x
  public :: MPI_Type_get_name
  public :: MPI_Type_get_true_extent
  public :: MPI_Type_get_true_extent_c
  public :: MPI_Type_get_true_extent_x
  public :: MPI_Type_get_value_index
  public :: MPI_Type_indexed
  public :: MPI_Type_indexed_c
  public :: MPI_Type_match_size
  public :: MPI_Type_set_attr
  public :: MPI_Type_set_name
  public :: MPI_Type_size
  public :: MPI_Type_size_c
  public :: MPI_Type_size_x
  public :: MPI_Type_vector
  public :: MPI_Type_vector_c
  public :: MPI_Unpack
  public :: MPI_Unpack_c
  public :: MPI_Unpack_external
  public :: MPI_Unpack_external_c
  public :: MPI_Unpublish_name
  public :: MPI_Wait
  public :: MPI_Waitall
  public :: MPI_Waitany
  public :: MPI_Waitsome
  public :: MPI_Win_allocate
  public :: MPI_Win_allocate_c
  public :: MPI_Win_allocate_shared
  public :: MPI_Win_allocate_shared_c
  public :: MPI_Win_attach
  public :: MPI_Win_call_errhandler
  public :: MPI_Win_complete
  public :: MPI_Win_create
  public :: MPI_Win_create_c
  public :: MPI_Win_create_dynamic
  public :: MPI_Win_create_errhandler
  public :: MPI_Win_create_keyval
  public :: MPI_Win_delete_attr
  public :: MPI_Win_detach
  public :: MPI_Win_fence
  public :: MPI_Win_flush
  public :: MPI_Win_flush_all
  public :: MPI_Win_flush_local
  public :: MPI_Win_flush_local_all
  public :: MPI_Win_free
  public :: MPI_Win_free_keyval
  public :: MPI_Win_get_attr
  public :: MPI_Win_get_errhandler
  public :: MPI_Win_get_group
  public :: MPI_Win_get_info
  public :: MPI_Win_get_name
  public :: MPI_Win_lock
  public :: MPI_Win_lock_all
  public :: MPI_Win_post
  public :: MPI_Win_set_attr
  public :: MPI_Win_set_errhandler
  public :: MPI_Win_set_info
  public :: MPI_Win_set_name
  public :: MPI_Win_shared_query
  public :: MPI_Win_shared_query_c
  public :: MPI_Win_start
  public :: MPI_Win_sync
  public :: MPI_Win_test
  public :: MPI_Win_unlock
  public :: MPI_Win_unlock_all
  public :: MPI_Win_wait
  public :: MPI_Wtick
  public :: MPI_Wtime

contains

  subroutine MPI_Abi_get_fortran_booleans( &
    logical_size, &
    logical_true, &
    logical_false, &
    is_set, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: logical_size
    !gcc$ attributes no_arg_check :: logical_true
    integer :: logical_true(*)
    !gcc$ attributes no_arg_check :: logical_false
    integer :: logical_false(*)
    logical, intent(out) :: is_set
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_get_fortran_booleans( &
      logical_size, &
      logical_true, &
      logical_false, &
      is_set, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_get_fortran_booleans

  subroutine MPI_Abi_get_fortran_info( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(out) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_get_fortran_info( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_get_fortran_info

  subroutine MPI_Abi_get_info( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(out) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_get_info( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_get_info

  subroutine MPI_Abi_get_version( &
    abi_major, &
    abi_minor, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out) :: abi_major
    integer, intent(out) :: abi_minor
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_get_version( &
      abi_major, &
      abi_minor, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_get_version

  subroutine MPI_Abi_set_fortran_booleans( &
    logical_size, &
    logical_true, &
    logical_false, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: logical_size
    !gcc$ attributes no_arg_check :: logical_true
    integer :: logical_true(*)
    !gcc$ attributes no_arg_check :: logical_false
    integer :: logical_false(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_set_fortran_booleans( &
      logical_size, &
      logical_true, &
      logical_false, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_set_fortran_booleans

  subroutine MPI_Abi_set_fortran_info( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abi_set_fortran_info( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abi_set_fortran_info

  subroutine MPI_Abort( &
    comm, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Abort( &
      comm%MPI_VAL, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Abort

  subroutine MPI_Accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Accumulate( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Accumulate

  subroutine MPI_Accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Accumulate_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Accumulate_c

  subroutine MPI_Add_error_class( &
    errorclass, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out) :: errorclass
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Add_error_class( &
      errorclass, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Add_error_class

  subroutine MPI_Add_error_code( &
    errorclass, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorclass
    integer, intent(out) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Add_error_code( &
      errorclass, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Add_error_code

  subroutine MPI_Add_error_string( &
    errorcode, &
    string, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorcode
    character*(*), intent(in) :: string
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Add_error_string( &
      errorcode, &
      string, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Add_error_string

  function MPI_Aint_add( &
    base, &
    disp &
  ) result(result)
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND) :: result
    integer(MPI_ADDRESS_KIND), intent(in) :: base
    integer(MPI_ADDRESS_KIND), intent(in) :: disp
    result = MPIF_Aint_add( &
      base, &
      disp &
    )
  end function MPI_Aint_add

  function MPI_Aint_diff( &
    addr1, &
    addr2 &
  ) result(result)
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND) :: result
    integer(MPI_ADDRESS_KIND), intent(in) :: addr1
    integer(MPI_ADDRESS_KIND), intent(in) :: addr2
    result = MPIF_Aint_diff( &
      addr1, &
      addr2 &
    )
  end function MPI_Aint_diff

  subroutine MPI_Allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgather

  subroutine MPI_Allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgather_c

  subroutine MPI_Allgather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgather_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgather_init

  subroutine MPI_Allgather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgather_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgather_init_c

  subroutine MPI_Allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgatherv

  subroutine MPI_Allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgatherv_c

  subroutine MPI_Allgatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgatherv_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgatherv_init

  subroutine MPI_Allgatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allgatherv_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allgatherv_init_c

  subroutine MPI_Alloc_mem( &
    size, &
    info, &
    baseptr, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    type(MPI_Info), intent(in) :: info
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alloc_mem( &
      size, &
      info%MPI_VAL, &
      baseptr, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alloc_mem

  subroutine MPI_Allreduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allreduce( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allreduce

  subroutine MPI_Allreduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allreduce_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allreduce_c

  subroutine MPI_Allreduce_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allreduce_init( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allreduce_init

  subroutine MPI_Allreduce_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Allreduce_init_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Allreduce_init_c

  subroutine MPI_Alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoall( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoall

  subroutine MPI_Alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoall_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoall_c

  subroutine MPI_Alltoall_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoall_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoall_init

  subroutine MPI_Alltoall_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoall_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoall_init_c

  subroutine MPI_Alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallv( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallv

  subroutine MPI_Alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallv_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallv_c

  subroutine MPI_Alltoallv_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallv_init( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallv_init

  subroutine MPI_Alltoallv_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallv_init_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallv_init_c

  subroutine MPI_Alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallw( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallw

  subroutine MPI_Alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallw_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallw_c

  subroutine MPI_Alltoallw_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallw_init( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallw_init

  subroutine MPI_Alltoallw_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Alltoallw_init_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Alltoallw_init_c

  subroutine MPI_Attr_delete( &
    comm, &
    keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Attr_delete( &
      comm%MPI_VAL, &
      keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Attr_delete

  subroutine MPI_Attr_get( &
    comm, &
    keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: keyval
    integer, intent(out) :: attribute_val
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Attr_get( &
      comm%MPI_VAL, &
      keyval, &
      attribute_val, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Attr_get

  subroutine MPI_Attr_put( &
    comm, &
    keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: keyval
    integer, intent(in) :: attribute_val
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Attr_put( &
      comm%MPI_VAL, &
      keyval, &
      attribute_val, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Attr_put

  subroutine MPI_Barrier( &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Barrier( &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Barrier

  subroutine MPI_Barrier_init( &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Barrier_init( &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Barrier_init

  subroutine MPI_Bcast( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bcast( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bcast

  subroutine MPI_Bcast_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bcast_c( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bcast_c

  subroutine MPI_Bcast_init( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bcast_init( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bcast_init

  subroutine MPI_Bcast_init_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bcast_init_c( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bcast_init_c

  subroutine MPI_Bsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bsend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bsend

  subroutine MPI_Bsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bsend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bsend_c

  subroutine MPI_Bsend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bsend_init( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bsend_init

  subroutine MPI_Bsend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Bsend_init_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Bsend_init_c

  subroutine MPI_Buffer_attach( &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_attach( &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_attach

  subroutine MPI_Buffer_attach_c( &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_attach_c( &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_attach_c

  subroutine MPI_Buffer_detach( &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_detach( &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_detach

  subroutine MPI_Buffer_detach_c( &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_detach_c( &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_detach_c

  subroutine MPI_Buffer_flush( &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_flush( &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_flush

  subroutine MPI_Buffer_iflush( &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Buffer_iflush( &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Buffer_iflush

  subroutine MPI_Cancel( &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(inout) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cancel( &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cancel

  subroutine MPI_Cart_coords( &
    comm, &
    rank, &
    maxdims, &
    coords, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: rank
    integer, intent(in) :: maxdims
    integer, intent(out) :: coords(maxdims)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_coords( &
      comm%MPI_VAL, &
      rank, &
      maxdims, &
      coords, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_coords

  subroutine MPI_Cart_create( &
    comm_old, &
    ndims, &
    dims, &
    periods, &
    reorder, &
    comm_cart, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm_old
    integer, intent(in) :: ndims
    integer, intent(in) :: dims(ndims)
    logical, intent(in) :: periods(*)
    logical, intent(in) :: reorder
    type(MPI_Comm), intent(out) :: comm_cart
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_create( &
      comm_old%MPI_VAL, &
      ndims, &
      dims, &
      periods, &
      reorder, &
      comm_cart%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_create

  subroutine MPI_Cart_get( &
    comm, &
    maxdims, &
    dims, &
    periods, &
    coords, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: maxdims
    integer, intent(out) :: dims(maxdims)
    logical, intent(out) :: periods(*)
    integer, intent(out) :: coords(maxdims)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_get( &
      comm%MPI_VAL, &
      maxdims, &
      dims, &
      periods, &
      coords, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_get

  subroutine MPI_Cart_map( &
    comm, &
    ndims, &
    dims, &
    periods, &
    newrank, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: ndims
    integer, intent(in) :: dims(ndims)
    logical, intent(in) :: periods(*)
    integer, intent(out) :: newrank
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_map( &
      comm%MPI_VAL, &
      ndims, &
      dims, &
      periods, &
      newrank, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_map

  subroutine MPI_Cart_rank( &
    comm, &
    coords, &
    rank, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: coords(*)
    integer, intent(out) :: rank
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_rank( &
      comm%MPI_VAL, &
      coords, &
      rank, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_rank

  subroutine MPI_Cart_shift( &
    comm, &
    direction, &
    disp, &
    rank_source, &
    rank_dest, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: direction
    integer, intent(in) :: disp
    integer, intent(out) :: rank_source
    integer, intent(out) :: rank_dest
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_shift( &
      comm%MPI_VAL, &
      direction, &
      disp, &
      rank_source, &
      rank_dest, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_shift

  subroutine MPI_Cart_sub( &
    comm, &
    remain_dims, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    logical, intent(in) :: remain_dims(*)
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cart_sub( &
      comm%MPI_VAL, &
      remain_dims, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cart_sub

  subroutine MPI_Cartdim_get( &
    comm, &
    ndims, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: ndims
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Cartdim_get( &
      comm%MPI_VAL, &
      ndims, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Cartdim_get

  subroutine MPI_Close_port( &
    port_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: port_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Close_port( &
      port_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Close_port

  subroutine MPI_Comm_accept( &
    port_name, &
    info, &
    root, &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: port_name
    type(MPI_Info), intent(in) :: info
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_accept( &
      port_name, &
      info%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_accept

  subroutine MPI_Comm_attach_buffer( &
    comm, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_attach_buffer( &
      comm%MPI_VAL, &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_attach_buffer

  subroutine MPI_Comm_attach_buffer_c( &
    comm, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_attach_buffer_c( &
      comm%MPI_VAL, &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_attach_buffer_c

  subroutine MPI_Comm_call_errhandler( &
    comm, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_call_errhandler( &
      comm%MPI_VAL, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_call_errhandler

  subroutine MPI_Comm_compare( &
    comm1, &
    comm2, &
    result, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm1
    type(MPI_Comm), intent(in) :: comm2
    integer, intent(out) :: result
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_compare( &
      comm1%MPI_VAL, &
      comm2%MPI_VAL, &
      result, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_compare

  subroutine MPI_Comm_connect( &
    port_name, &
    info, &
    root, &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: port_name
    type(MPI_Info), intent(in) :: info
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_connect( &
      port_name, &
      info%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_connect

  subroutine MPI_Comm_create( &
    comm, &
    group, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Group), intent(in) :: group
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_create( &
      comm%MPI_VAL, &
      group%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_create

  subroutine MPI_Comm_create_errhandler( &
    comm_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Comm_errhandler_function) :: comm_errhandler_fn
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_create_errhandler( &
      comm_errhandler_fn, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_create_errhandler

  subroutine MPI_Comm_create_from_group( &
    group, &
    stringtag, &
    info, &
    errhandler, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    character*(*), intent(in) :: stringtag
    type(MPI_Info), intent(in) :: info
    type(MPI_Errhandler), intent(in) :: errhandler
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_create_from_group( &
      group%MPI_VAL, &
      stringtag, &
      info%MPI_VAL, &
      errhandler%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_create_from_group

  subroutine MPI_Comm_create_group( &
    comm, &
    group, &
    tag, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: tag
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_create_group( &
      comm%MPI_VAL, &
      group%MPI_VAL, &
      tag, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_create_group

  subroutine MPI_Comm_create_keyval( &
    comm_copy_attr_fn, &
    comm_delete_attr_fn, &
    comm_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Comm_copy_attr_function) :: comm_copy_attr_fn
    procedure(MPI_Comm_delete_attr_function) :: comm_delete_attr_fn
    integer, intent(out) :: comm_keyval
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_create_keyval( &
      comm_copy_attr_fn, &
      comm_delete_attr_fn, &
      comm_keyval, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_create_keyval

  subroutine MPI_Comm_delete_attr( &
    comm, &
    comm_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: comm_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_delete_attr( &
      comm%MPI_VAL, &
      comm_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_delete_attr

  subroutine MPI_Comm_detach_buffer( &
    comm, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_detach_buffer( &
      comm%MPI_VAL, &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_detach_buffer

  subroutine MPI_Comm_detach_buffer_c( &
    comm, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_detach_buffer_c( &
      comm%MPI_VAL, &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_detach_buffer_c

  subroutine MPI_Comm_disconnect( &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(inout) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_disconnect( &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_disconnect

  subroutine MPI_Comm_dup( &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_dup( &
      comm%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_dup

  subroutine MPI_Comm_dup_with_info( &
    comm, &
    info, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_dup_with_info( &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_dup_with_info

  subroutine MPI_Comm_flush_buffer( &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_flush_buffer( &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_flush_buffer

  subroutine MPI_Comm_free( &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(inout) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_free( &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_free

  subroutine MPI_Comm_free_keyval( &
    comm_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(inout) :: comm_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_free_keyval( &
      comm_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_free_keyval

  subroutine MPI_Comm_get_attr( &
    comm, &
    comm_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: comm_keyval
    integer, intent(out) :: attribute_val
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_get_attr( &
      comm%MPI_VAL, &
      comm_keyval, &
      attribute_val, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_get_attr

  subroutine MPI_Comm_get_errhandler( &
    comm, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_get_errhandler( &
      comm%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_get_errhandler

  subroutine MPI_Comm_get_info( &
    comm, &
    info_used, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(out) :: info_used
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_get_info( &
      comm%MPI_VAL, &
      info_used%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_get_info

  subroutine MPI_Comm_get_name( &
    comm, &
    comm_name, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    character*(MPI_MAX_OBJECT_NAME), intent(out) :: comm_name
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_get_name( &
      comm%MPI_VAL, &
      comm_name, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_get_name

  subroutine MPI_Comm_get_parent( &
    parent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(out) :: parent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_get_parent( &
      parent%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_get_parent

  subroutine MPI_Comm_group( &
    comm, &
    group, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Group), intent(out) :: group
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_group( &
      comm%MPI_VAL, &
      group%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_group

  subroutine MPI_Comm_idup( &
    comm, &
    newcomm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: newcomm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_idup( &
      comm%MPI_VAL, &
      newcomm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_idup

  subroutine MPI_Comm_idup_with_info( &
    comm, &
    info, &
    newcomm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(out) :: newcomm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_idup_with_info( &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      newcomm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_idup_with_info

  subroutine MPI_Comm_iflush_buffer( &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_iflush_buffer( &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_iflush_buffer

  subroutine MPI_Comm_join( &
    fd, &
    intercomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: fd
    type(MPI_Comm), intent(out) :: intercomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_join( &
      fd, &
      intercomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_join

  subroutine MPI_Comm_rank( &
    comm, &
    rank, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: rank
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_rank( &
      comm%MPI_VAL, &
      rank, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_rank

  subroutine MPI_Comm_remote_group( &
    comm, &
    group, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Group), intent(out) :: group
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_remote_group( &
      comm%MPI_VAL, &
      group%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_remote_group

  subroutine MPI_Comm_remote_size( &
    comm, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_remote_size( &
      comm%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_remote_size

  subroutine MPI_Comm_set_attr( &
    comm, &
    comm_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: comm_keyval
    integer, intent(in) :: attribute_val
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_set_attr( &
      comm%MPI_VAL, &
      comm_keyval, &
      attribute_val, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_set_attr

  subroutine MPI_Comm_set_errhandler( &
    comm, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Errhandler), intent(in) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_set_errhandler( &
      comm%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_set_errhandler

  subroutine MPI_Comm_set_info( &
    comm, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_set_info( &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_set_info

  subroutine MPI_Comm_set_name( &
    comm, &
    comm_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    character*(*), intent(in) :: comm_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_set_name( &
      comm%MPI_VAL, &
      comm_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_set_name

  subroutine MPI_Comm_size( &
    comm, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_size( &
      comm%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_size

  subroutine MPI_Comm_spawn( &
    command, &
    argv, &
    maxprocs, &
    info, &
    root, &
    comm, &
    intercomm, &
    array_of_errcodes, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: command
    character*(*), intent(in) :: argv(*)
    integer, intent(in) :: maxprocs
    type(MPI_Info), intent(in) :: info
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: intercomm
    integer :: array_of_errcodes(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_spawn( &
      command, &
      argv, &
      maxprocs, &
      info%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      intercomm%MPI_VAL, &
      array_of_errcodes, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_spawn

  subroutine MPI_Comm_spawn_multiple( &
    count, &
    array_of_commands, &
    array_of_argv, &
    array_of_maxprocs, &
    array_of_info, &
    root, &
    comm, &
    intercomm, &
    array_of_errcodes, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    character*(*), intent(in) :: array_of_commands(*)
    character*(*), intent(in) :: array_of_argv(count, *)
    integer, intent(in) :: array_of_maxprocs(count)
    type(MPI_Info), intent(in) :: array_of_info(*)
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Comm), intent(out) :: intercomm
    integer :: array_of_errcodes(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_spawn_multiple( &
      count, &
      array_of_commands, &
      array_of_argv, &
      array_of_maxprocs, &
      array_of_info%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      intercomm%MPI_VAL, &
      array_of_errcodes, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_spawn_multiple

  subroutine MPI_Comm_split( &
    comm, &
    color, &
    key, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: color
    integer, intent(in) :: key
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_split( &
      comm%MPI_VAL, &
      color, &
      key, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_split

  subroutine MPI_Comm_split_type( &
    comm, &
    split_type, &
    key, &
    info, &
    newcomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: split_type
    integer, intent(in) :: key
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(out) :: newcomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_split_type( &
      comm%MPI_VAL, &
      split_type, &
      key, &
      info%MPI_VAL, &
      newcomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_split_type

  subroutine MPI_Comm_test_inter( &
    comm, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Comm_test_inter( &
      comm%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Comm_test_inter

  subroutine MPI_Compare_and_swap( &
    origin_addr, &
    compare_addr, &
    result_addr, &
    datatype, &
    target_rank, &
    target_disp, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    !gcc$ attributes no_arg_check :: compare_addr
    integer :: compare_addr(*)
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Compare_and_swap( &
      origin_addr, &
      compare_addr, &
      result_addr, &
      datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Compare_and_swap

  subroutine MPI_Dims_create( &
    nnodes, &
    ndims, &
    dims, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: nnodes
    integer, intent(in) :: ndims
    integer, intent(inout) :: dims(ndims)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Dims_create( &
      nnodes, &
      ndims, &
      dims, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Dims_create

  subroutine MPI_Dist_graph_create( &
    comm_old, &
    n, &
    sources, &
    degrees, &
    destinations, &
    weights, &
    info, &
    reorder, &
    comm_dist_graph, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm_old
    integer, intent(in) :: n
    integer, intent(in) :: sources(n)
    integer, intent(in) :: degrees(n)
    integer, intent(in) :: destinations(*)
    integer, intent(in) :: weights(*)
    type(MPI_Info), intent(in) :: info
    logical, intent(in) :: reorder
    type(MPI_Comm), intent(out) :: comm_dist_graph
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Dist_graph_create( &
      comm_old%MPI_VAL, &
      n, &
      sources, &
      degrees, &
      destinations, &
      weights, &
      info%MPI_VAL, &
      reorder, &
      comm_dist_graph%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Dist_graph_create

  subroutine MPI_Dist_graph_create_adjacent( &
    comm_old, &
    indegree, &
    sources, &
    sourceweights, &
    outdegree, &
    destinations, &
    destweights, &
    info, &
    reorder, &
    comm_dist_graph, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm_old
    integer, intent(in) :: indegree
    integer, intent(in) :: sources(indegree)
    integer, intent(in) :: sourceweights(*)
    integer, intent(in) :: outdegree
    integer, intent(in) :: destinations(outdegree)
    integer, intent(in) :: destweights(*)
    type(MPI_Info), intent(in) :: info
    logical, intent(in) :: reorder
    type(MPI_Comm), intent(out) :: comm_dist_graph
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Dist_graph_create_adjacent( &
      comm_old%MPI_VAL, &
      indegree, &
      sources, &
      sourceweights, &
      outdegree, &
      destinations, &
      destweights, &
      info%MPI_VAL, &
      reorder, &
      comm_dist_graph%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Dist_graph_create_adjacent

  subroutine MPI_Dist_graph_neighbors( &
    comm, &
    maxindegree, &
    sources, &
    sourceweights, &
    maxoutdegree, &
    destinations, &
    destweights, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: maxindegree
    integer, intent(out) :: sources(maxindegree)
    integer :: sourceweights(*)
    integer, intent(in) :: maxoutdegree
    integer, intent(out) :: destinations(maxoutdegree)
    integer :: destweights(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Dist_graph_neighbors( &
      comm%MPI_VAL, &
      maxindegree, &
      sources, &
      sourceweights, &
      maxoutdegree, &
      destinations, &
      destweights, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Dist_graph_neighbors

  subroutine MPI_Dist_graph_neighbors_count( &
    comm, &
    indegree, &
    outdegree, &
    weighted, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: indegree
    integer, intent(out) :: outdegree
    logical, intent(out) :: weighted
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Dist_graph_neighbors_count( &
      comm%MPI_VAL, &
      indegree, &
      outdegree, &
      weighted, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Dist_graph_neighbors_count

  subroutine MPI_Errhandler_free( &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Errhandler), intent(inout) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Errhandler_free( &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Errhandler_free

  subroutine MPI_Error_class( &
    errorcode, &
    errorclass, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorcode
    integer, intent(out) :: errorclass
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Error_class( &
      errorcode, &
      errorclass, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Error_class

  subroutine MPI_Error_string( &
    errorcode, &
    string, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorcode
    character*(MPI_MAX_ERROR_STRING), intent(out) :: string
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Error_string( &
      errorcode, &
      string, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Error_string

  subroutine MPI_Exscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Exscan( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Exscan

  subroutine MPI_Exscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Exscan_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Exscan_c

  subroutine MPI_Exscan_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Exscan_init( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Exscan_init

  subroutine MPI_Exscan_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Exscan_init_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Exscan_init_c

  subroutine MPI_F_sync_reg( &
    buf &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    call MPIF_F_sync_reg( &
      buf &
    )
  end subroutine MPI_F_sync_reg

  subroutine MPI_Fetch_and_op( &
    origin_addr, &
    result_addr, &
    datatype, &
    target_rank, &
    target_disp, &
    op, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Fetch_and_op( &
      origin_addr, &
      result_addr, &
      datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Fetch_and_op

  subroutine MPI_File_call_errhandler( &
    fh, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_call_errhandler( &
      fh%MPI_VAL, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_call_errhandler

  subroutine MPI_File_close( &
    fh, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(inout) :: fh
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_close( &
      fh%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_close

  subroutine MPI_File_create_errhandler( &
    file_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_File_errhandler_function) :: file_errhandler_fn
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_create_errhandler( &
      file_errhandler_fn, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_create_errhandler

  subroutine MPI_File_delete( &
    filename, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: filename
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_delete( &
      filename, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_delete

  subroutine MPI_File_get_amode( &
    fh, &
    amode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer, intent(out) :: amode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_amode( &
      fh%MPI_VAL, &
      amode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_amode

  subroutine MPI_File_get_atomicity( &
    fh, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_atomicity( &
      fh%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_atomicity

  subroutine MPI_File_get_byte_offset( &
    fh, &
    offset, &
    disp, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    integer(MPI_OFFSET_KIND), intent(out) :: disp
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_byte_offset( &
      fh%MPI_VAL, &
      offset, &
      disp, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_byte_offset

  subroutine MPI_File_get_errhandler( &
    file, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: file
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_errhandler( &
      file%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_errhandler

  subroutine MPI_File_get_group( &
    fh, &
    group, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    type(MPI_Group), intent(out) :: group
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_group( &
      fh%MPI_VAL, &
      group%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_group

  subroutine MPI_File_get_info( &
    fh, &
    info_used, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    type(MPI_Info), intent(out) :: info_used
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_info( &
      fh%MPI_VAL, &
      info_used%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_info

  subroutine MPI_File_get_position( &
    fh, &
    offset, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(out) :: offset
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_position( &
      fh%MPI_VAL, &
      offset, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_position

  subroutine MPI_File_get_position_shared( &
    fh, &
    offset, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(out) :: offset
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_position_shared( &
      fh%MPI_VAL, &
      offset, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_position_shared

  subroutine MPI_File_get_size( &
    fh, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_size( &
      fh%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_size

  subroutine MPI_File_get_type_extent( &
    fh, &
    datatype, &
    extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_ADDRESS_KIND), intent(out) :: extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_type_extent( &
      fh%MPI_VAL, &
      datatype%MPI_VAL, &
      extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_type_extent

  subroutine MPI_File_get_type_extent_c( &
    fh, &
    datatype, &
    extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_type_extent_c( &
      fh%MPI_VAL, &
      datatype%MPI_VAL, &
      extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_type_extent_c

  subroutine MPI_File_get_view( &
    fh, &
    disp, &
    etype, &
    filetype, &
    datarep, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(out) :: disp
    type(MPI_Datatype), intent(out) :: etype
    type(MPI_Datatype), intent(out) :: filetype
    character*(*), intent(out) :: datarep
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_get_view( &
      fh%MPI_VAL, &
      disp, &
      etype%MPI_VAL, &
      filetype%MPI_VAL, &
      datarep, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_get_view

  subroutine MPI_File_iread( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread

  subroutine MPI_File_iread_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_c

  subroutine MPI_File_iread_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_all( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_all

  subroutine MPI_File_iread_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_all_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_all_c

  subroutine MPI_File_iread_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_at( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_at

  subroutine MPI_File_iread_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_at_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_at_c

  subroutine MPI_File_iread_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_at_all( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_at_all

  subroutine MPI_File_iread_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_at_all_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_at_all_c

  subroutine MPI_File_iread_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_shared( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_shared

  subroutine MPI_File_iread_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iread_shared_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iread_shared_c

  subroutine MPI_File_iwrite( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite

  subroutine MPI_File_iwrite_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_c

  subroutine MPI_File_iwrite_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_all( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_all

  subroutine MPI_File_iwrite_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_all_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_all_c

  subroutine MPI_File_iwrite_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_at( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_at

  subroutine MPI_File_iwrite_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_at_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_at_c

  subroutine MPI_File_iwrite_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_at_all( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_at_all

  subroutine MPI_File_iwrite_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_at_all_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_at_all_c

  subroutine MPI_File_iwrite_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_shared( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_shared

  subroutine MPI_File_iwrite_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_iwrite_shared_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_iwrite_shared_c

  subroutine MPI_File_open( &
    comm, &
    filename, &
    amode, &
    info, &
    fh, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    character*(*), intent(in) :: filename
    integer, intent(in) :: amode
    type(MPI_Info), intent(in) :: info
    type(MPI_File), intent(out) :: fh
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_open( &
      comm%MPI_VAL, &
      filename, &
      amode, &
      info%MPI_VAL, &
      fh%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_open

  subroutine MPI_File_preallocate( &
    fh, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_preallocate( &
      fh%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_preallocate

  subroutine MPI_File_read( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read

  subroutine MPI_File_read_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_c

  subroutine MPI_File_read_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_all( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_all

  subroutine MPI_File_read_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_all_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_all_c

  subroutine MPI_File_read_all_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_all_begin( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_all_begin

  subroutine MPI_File_read_all_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_all_begin_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_all_begin_c

  subroutine MPI_File_read_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_all_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_all_end

  subroutine MPI_File_read_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at

  subroutine MPI_File_read_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_c

  subroutine MPI_File_read_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_all( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_all

  subroutine MPI_File_read_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_all_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_all_c

  subroutine MPI_File_read_at_all_begin( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_all_begin( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_all_begin

  subroutine MPI_File_read_at_all_begin_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_all_begin_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_all_begin_c

  subroutine MPI_File_read_at_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_at_all_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_at_all_end

  subroutine MPI_File_read_ordered( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_ordered( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_ordered

  subroutine MPI_File_read_ordered_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_ordered_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_ordered_c

  subroutine MPI_File_read_ordered_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_ordered_begin( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_ordered_begin

  subroutine MPI_File_read_ordered_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_ordered_begin_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_ordered_begin_c

  subroutine MPI_File_read_ordered_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_ordered_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_ordered_end

  subroutine MPI_File_read_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_shared( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_shared

  subroutine MPI_File_read_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_read_shared_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_read_shared_c

  subroutine MPI_File_seek( &
    fh, &
    offset, &
    whence, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    integer, intent(in) :: whence
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_seek( &
      fh%MPI_VAL, &
      offset, &
      whence, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_seek

  subroutine MPI_File_seek_shared( &
    fh, &
    offset, &
    whence, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    integer, intent(in) :: whence
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_seek_shared( &
      fh%MPI_VAL, &
      offset, &
      whence, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_seek_shared

  subroutine MPI_File_set_atomicity( &
    fh, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    logical, intent(in) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_set_atomicity( &
      fh%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_set_atomicity

  subroutine MPI_File_set_errhandler( &
    file, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: file
    type(MPI_Errhandler), intent(in) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_set_errhandler( &
      file%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_set_errhandler

  subroutine MPI_File_set_info( &
    fh, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_set_info( &
      fh%MPI_VAL, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_set_info

  subroutine MPI_File_set_size( &
    fh, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_set_size( &
      fh%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_set_size

  subroutine MPI_File_set_view( &
    fh, &
    disp, &
    etype, &
    filetype, &
    datarep, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: disp
    type(MPI_Datatype), intent(in) :: etype
    type(MPI_Datatype), intent(in) :: filetype
    character*(*), intent(in) :: datarep
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_set_view( &
      fh%MPI_VAL, &
      disp, &
      etype%MPI_VAL, &
      filetype%MPI_VAL, &
      datarep, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_set_view

  subroutine MPI_File_sync( &
    fh, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_sync( &
      fh%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_sync

  subroutine MPI_File_write( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write

  subroutine MPI_File_write_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_c

  subroutine MPI_File_write_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_all( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_all

  subroutine MPI_File_write_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_all_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_all_c

  subroutine MPI_File_write_all_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_all_begin( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_all_begin

  subroutine MPI_File_write_all_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_all_begin_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_all_begin_c

  subroutine MPI_File_write_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_all_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_all_end

  subroutine MPI_File_write_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at

  subroutine MPI_File_write_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_c

  subroutine MPI_File_write_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_all( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_all

  subroutine MPI_File_write_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_all_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_all_c

  subroutine MPI_File_write_at_all_begin( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_all_begin( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_all_begin

  subroutine MPI_File_write_at_all_begin_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    integer(MPI_OFFSET_KIND), intent(in) :: offset
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_all_begin_c( &
      fh%MPI_VAL, &
      offset, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_all_begin_c

  subroutine MPI_File_write_at_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_at_all_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_at_all_end

  subroutine MPI_File_write_ordered( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_ordered( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_ordered

  subroutine MPI_File_write_ordered_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_ordered_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_ordered_c

  subroutine MPI_File_write_ordered_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_ordered_begin( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_ordered_begin

  subroutine MPI_File_write_ordered_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_ordered_begin_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_ordered_begin_c

  subroutine MPI_File_write_ordered_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_ordered_end( &
      fh%MPI_VAL, &
      buf, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_ordered_end

  subroutine MPI_File_write_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_shared( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_shared

  subroutine MPI_File_write_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_File), intent(in) :: fh
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_File_write_shared_c( &
      fh%MPI_VAL, &
      buf, &
      count, &
      datatype%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_File_write_shared_c

  subroutine MPI_Finalize( &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Finalize( &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Finalize

  subroutine MPI_Finalized( &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Finalized( &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Finalized

  subroutine MPI_Free_mem( &
    base, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Free_mem( &
      base, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Free_mem

  subroutine MPI_Gather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gather

  subroutine MPI_Gather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gather_c

  subroutine MPI_Gather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gather_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gather_init

  subroutine MPI_Gather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gather_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gather_init_c

  subroutine MPI_Gatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gatherv

  subroutine MPI_Gatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gatherv_c

  subroutine MPI_Gatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gatherv_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gatherv_init

  subroutine MPI_Gatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Gatherv_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Gatherv_init_c

  subroutine MPI_Get( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get

  subroutine MPI_Get_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_c

  subroutine MPI_Get_accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer, intent(in) :: result_count
    type(MPI_Datatype), intent(in) :: result_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_accumulate( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      result_addr, &
      result_count, &
      result_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_accumulate

  subroutine MPI_Get_accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: result_count
    type(MPI_Datatype), intent(in) :: result_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_accumulate_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      result_addr, &
      result_count, &
      result_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_accumulate_c

  subroutine MPI_Get_address( &
    location, &
    address, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: location
    integer :: location(*)
    integer(MPI_ADDRESS_KIND), intent(out) :: address
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_address( &
      location, &
      address, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_address

  subroutine MPI_Get_count( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_count( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_count

  subroutine MPI_Get_count_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_count_c( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_count_c

  subroutine MPI_Get_elements( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_elements( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_elements

  subroutine MPI_Get_elements_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_elements_c( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_elements_c

  subroutine MPI_Get_elements_x( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_elements_x( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_elements_x

  subroutine MPI_Get_hw_resource_info( &
    hw_info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(out) :: hw_info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_hw_resource_info( &
      hw_info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_hw_resource_info

  subroutine MPI_Get_library_version( &
    version, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(MPI_MAX_LIBRARY_VERSION_STRING), intent(out) :: version
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_library_version( &
      version, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_library_version

  subroutine MPI_Get_processor_name( &
    name, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(MPI_MAX_PROCESSOR_NAME), intent(out) :: name
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_processor_name( &
      name, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_processor_name

  subroutine MPI_Get_version( &
    version, &
    subversion, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out) :: version
    integer, intent(out) :: subversion
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Get_version( &
      version, &
      subversion, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Get_version

  subroutine MPI_Graph_create( &
    comm_old, &
    nnodes, &
    index, &
    edges, &
    reorder, &
    comm_graph, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm_old
    integer, intent(in) :: nnodes
    integer, intent(in) :: index(nnodes)
    integer, intent(in) :: edges(*)
    logical, intent(in) :: reorder
    type(MPI_Comm), intent(out) :: comm_graph
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graph_create( &
      comm_old%MPI_VAL, &
      nnodes, &
      index, &
      edges, &
      reorder, &
      comm_graph%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graph_create

  subroutine MPI_Graph_get( &
    comm, &
    maxindex, &
    maxedges, &
    index, &
    edges, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: maxindex
    integer, intent(in) :: maxedges
    integer, intent(out) :: index(maxindex)
    integer, intent(out) :: edges(maxedges)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graph_get( &
      comm%MPI_VAL, &
      maxindex, &
      maxedges, &
      index, &
      edges, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graph_get

  subroutine MPI_Graph_map( &
    comm, &
    nnodes, &
    index, &
    edges, &
    newrank, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: nnodes
    integer, intent(in) :: index(nnodes)
    integer, intent(in) :: edges(*)
    integer, intent(out) :: newrank
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graph_map( &
      comm%MPI_VAL, &
      nnodes, &
      index, &
      edges, &
      newrank, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graph_map

  subroutine MPI_Graph_neighbors( &
    comm, &
    rank, &
    maxneighbors, &
    neighbors, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: rank
    integer, intent(in) :: maxneighbors
    integer, intent(out) :: neighbors(maxneighbors)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graph_neighbors( &
      comm%MPI_VAL, &
      rank, &
      maxneighbors, &
      neighbors, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graph_neighbors

  subroutine MPI_Graph_neighbors_count( &
    comm, &
    rank, &
    nneighbors, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(in) :: rank
    integer, intent(out) :: nneighbors
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graph_neighbors_count( &
      comm%MPI_VAL, &
      rank, &
      nneighbors, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graph_neighbors_count

  subroutine MPI_Graphdims_get( &
    comm, &
    nnodes, &
    nedges, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: nnodes
    integer, intent(out) :: nedges
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Graphdims_get( &
      comm%MPI_VAL, &
      nnodes, &
      nedges, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Graphdims_get

  subroutine MPI_Grequest_complete( &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(in) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Grequest_complete( &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Grequest_complete

  subroutine MPI_Grequest_start( &
    query_fn, &
    free_fn, &
    cancel_fn, &
    extra_state, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Grequest_query_function) :: query_fn
    procedure(MPI_Grequest_free_function) :: free_fn
    procedure(MPI_Grequest_cancel_function) :: cancel_fn
    integer, intent(in) :: extra_state
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Grequest_start( &
      query_fn, &
      free_fn, &
      cancel_fn, &
      extra_state, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Grequest_start

  subroutine MPI_Group_compare( &
    group1, &
    group2, &
    result, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group1
    type(MPI_Group), intent(in) :: group2
    integer, intent(out) :: result
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_compare( &
      group1%MPI_VAL, &
      group2%MPI_VAL, &
      result, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_compare

  subroutine MPI_Group_difference( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group1
    type(MPI_Group), intent(in) :: group2
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_difference( &
      group1%MPI_VAL, &
      group2%MPI_VAL, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_difference

  subroutine MPI_Group_excl( &
    group, &
    n, &
    ranks, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: n
    integer, intent(in) :: ranks(n)
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_excl( &
      group%MPI_VAL, &
      n, &
      ranks, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_excl

  subroutine MPI_Group_free( &
    group, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(inout) :: group
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_free( &
      group%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_free

  subroutine MPI_Group_from_session_pset( &
    session, &
    pset_name, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    character*(*), intent(in) :: pset_name
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_from_session_pset( &
      session%MPI_VAL, &
      pset_name, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_from_session_pset

  subroutine MPI_Group_incl( &
    group, &
    n, &
    ranks, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: n
    integer, intent(in) :: ranks(n)
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_incl( &
      group%MPI_VAL, &
      n, &
      ranks, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_incl

  subroutine MPI_Group_intersection( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group1
    type(MPI_Group), intent(in) :: group2
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_intersection( &
      group1%MPI_VAL, &
      group2%MPI_VAL, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_intersection

  subroutine MPI_Group_range_excl( &
    group, &
    n, &
    ranges, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: n
    integer, intent(in) :: ranges(3, n)
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_range_excl( &
      group%MPI_VAL, &
      n, &
      ranges, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_range_excl

  subroutine MPI_Group_range_incl( &
    group, &
    n, &
    ranges, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: n
    integer, intent(in) :: ranges(3, n)
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_range_incl( &
      group%MPI_VAL, &
      n, &
      ranges, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_range_incl

  subroutine MPI_Group_rank( &
    group, &
    rank, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(out) :: rank
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_rank( &
      group%MPI_VAL, &
      rank, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_rank

  subroutine MPI_Group_size( &
    group, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_size( &
      group%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_size

  subroutine MPI_Group_translate_ranks( &
    group1, &
    n, &
    ranks1, &
    group2, &
    ranks2, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group1
    integer, intent(in) :: n
    integer, intent(in) :: ranks1(n)
    type(MPI_Group), intent(in) :: group2
    integer, intent(out) :: ranks2(n)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_translate_ranks( &
      group1%MPI_VAL, &
      n, &
      ranks1, &
      group2%MPI_VAL, &
      ranks2, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_translate_ranks

  subroutine MPI_Group_union( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group1
    type(MPI_Group), intent(in) :: group2
    type(MPI_Group), intent(out) :: newgroup
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Group_union( &
      group1%MPI_VAL, &
      group2%MPI_VAL, &
      newgroup%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Group_union

  subroutine MPI_Iallgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallgather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallgather

  subroutine MPI_Iallgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallgather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallgather_c

  subroutine MPI_Iallgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallgatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallgatherv

  subroutine MPI_Iallgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallgatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallgatherv_c

  subroutine MPI_Iallreduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallreduce( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallreduce

  subroutine MPI_Iallreduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iallreduce_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iallreduce_c

  subroutine MPI_Ialltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoall( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoall

  subroutine MPI_Ialltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoall_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoall_c

  subroutine MPI_Ialltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoallv( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoallv

  subroutine MPI_Ialltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoallv_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoallv_c

  subroutine MPI_Ialltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoallw( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoallw

  subroutine MPI_Ialltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ialltoallw_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ialltoallw_c

  subroutine MPI_Ibarrier( &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ibarrier( &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ibarrier

  subroutine MPI_Ibcast( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ibcast( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ibcast

  subroutine MPI_Ibcast_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ibcast_c( &
      buffer, &
      count, &
      datatype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ibcast_c

  subroutine MPI_Ibsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ibsend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ibsend

  subroutine MPI_Ibsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ibsend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ibsend_c

  subroutine MPI_Iexscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iexscan( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iexscan

  subroutine MPI_Iexscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iexscan_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iexscan_c

  subroutine MPI_Igather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Igather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Igather

  subroutine MPI_Igather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Igather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Igather_c

  subroutine MPI_Igatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Igatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Igatherv

  subroutine MPI_Igatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Igatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Igatherv_c

  subroutine MPI_Improbe( &
    source, &
    tag, &
    comm, &
    flag, &
    message, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    logical, intent(out) :: flag
    type(MPI_Message), intent(out) :: message
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Improbe( &
      source, &
      tag, &
      comm%MPI_VAL, &
      flag, &
      message%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Improbe

  subroutine MPI_Imrecv( &
    buf, &
    count, &
    datatype, &
    message, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Message), intent(inout) :: message
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Imrecv( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      message%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Imrecv

  subroutine MPI_Imrecv_c( &
    buf, &
    count, &
    datatype, &
    message, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Message), intent(inout) :: message
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Imrecv_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      message%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Imrecv_c

  subroutine MPI_Ineighbor_allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_allgather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_allgather

  subroutine MPI_Ineighbor_allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_allgather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_allgather_c

  subroutine MPI_Ineighbor_allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_allgatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_allgatherv

  subroutine MPI_Ineighbor_allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_allgatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_allgatherv_c

  subroutine MPI_Ineighbor_alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoall( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoall

  subroutine MPI_Ineighbor_alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoall_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoall_c

  subroutine MPI_Ineighbor_alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoallv( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoallv

  subroutine MPI_Ineighbor_alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoallv_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoallv_c

  subroutine MPI_Ineighbor_alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoallw( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoallw

  subroutine MPI_Ineighbor_alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ineighbor_alltoallw_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ineighbor_alltoallw_c

  subroutine MPI_Info_create( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(out) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_create( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_create

  subroutine MPI_Info_create_env( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(out) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_create_env( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_create_env

  subroutine MPI_Info_delete( &
    info, &
    key, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: key
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_delete( &
      info%MPI_VAL, &
      key, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_delete

  subroutine MPI_Info_dup( &
    info, &
    newinfo, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    type(MPI_Info), intent(out) :: newinfo
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_dup( &
      info%MPI_VAL, &
      newinfo%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_dup

  subroutine MPI_Info_free( &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(inout) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_free( &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_free

  subroutine MPI_Info_get( &
    info, &
    key, &
    valuelen, &
    value, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: key
    integer, intent(in) :: valuelen
    character*(valuelen), intent(out) :: value
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_get( &
      info%MPI_VAL, &
      key, &
      valuelen, &
      value, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_get

  subroutine MPI_Info_get_nkeys( &
    info, &
    nkeys, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    integer, intent(out) :: nkeys
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_get_nkeys( &
      info%MPI_VAL, &
      nkeys, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_get_nkeys

  subroutine MPI_Info_get_nthkey( &
    info, &
    n, &
    key, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    integer, intent(in) :: n
    character*(*), intent(out) :: key
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_get_nthkey( &
      info%MPI_VAL, &
      n, &
      key, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_get_nthkey

  subroutine MPI_Info_get_string( &
    info, &
    key, &
    buflen, &
    value, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: key
    integer, intent(inout) :: buflen
    character*(*), intent(out) :: value
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_get_string( &
      info%MPI_VAL, &
      key, &
      buflen, &
      value, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_get_string

  subroutine MPI_Info_get_valuelen( &
    info, &
    key, &
    valuelen, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: key
    integer, intent(out) :: valuelen
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_get_valuelen( &
      info%MPI_VAL, &
      key, &
      valuelen, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_get_valuelen

  subroutine MPI_Info_set( &
    info, &
    key, &
    value, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: key
    character*(*), intent(in) :: value
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Info_set( &
      info%MPI_VAL, &
      key, &
      value, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Info_set

  subroutine MPI_Init( &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Init( &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Init

  subroutine MPI_Init_thread( &
    required, &
    provided, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: required
    integer, intent(out) :: provided
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Init_thread( &
      required, &
      provided, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Init_thread

  subroutine MPI_Initialized( &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Initialized( &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Initialized

  subroutine MPI_Intercomm_create( &
    local_comm, &
    local_leader, &
    peer_comm, &
    remote_leader, &
    tag, &
    newintercomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: local_comm
    integer, intent(in) :: local_leader
    type(MPI_Comm), intent(in) :: peer_comm
    integer, intent(in) :: remote_leader
    integer, intent(in) :: tag
    type(MPI_Comm), intent(out) :: newintercomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Intercomm_create( &
      local_comm%MPI_VAL, &
      local_leader, &
      peer_comm%MPI_VAL, &
      remote_leader, &
      tag, &
      newintercomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Intercomm_create

  subroutine MPI_Intercomm_create_from_groups( &
    local_group, &
    local_leader, &
    remote_group, &
    remote_leader, &
    stringtag, &
    info, &
    errhandler, &
    newintercomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: local_group
    integer, intent(in) :: local_leader
    type(MPI_Group), intent(in) :: remote_group
    integer, intent(in) :: remote_leader
    character*(*), intent(in) :: stringtag
    type(MPI_Info), intent(in) :: info
    type(MPI_Errhandler), intent(in) :: errhandler
    type(MPI_Comm), intent(out) :: newintercomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Intercomm_create_from_groups( &
      local_group%MPI_VAL, &
      local_leader, &
      remote_group%MPI_VAL, &
      remote_leader, &
      stringtag, &
      info%MPI_VAL, &
      errhandler%MPI_VAL, &
      newintercomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Intercomm_create_from_groups

  subroutine MPI_Intercomm_merge( &
    intercomm, &
    high, &
    newintracomm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: intercomm
    logical, intent(in) :: high
    type(MPI_Comm), intent(out) :: newintracomm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Intercomm_merge( &
      intercomm%MPI_VAL, &
      high, &
      newintracomm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Intercomm_merge

  subroutine MPI_Iprobe( &
    source, &
    tag, &
    comm, &
    flag, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iprobe( &
      source, &
      tag, &
      comm%MPI_VAL, &
      flag, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iprobe

  subroutine MPI_Irecv( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Irecv( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Irecv

  subroutine MPI_Irecv_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Irecv_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Irecv_c

  subroutine MPI_Ireduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce

  subroutine MPI_Ireduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce_c

  subroutine MPI_Ireduce_scatter( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce_scatter( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce_scatter

  subroutine MPI_Ireduce_scatter_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce_scatter_c( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce_scatter_c

  subroutine MPI_Ireduce_scatter_block( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce_scatter_block( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce_scatter_block

  subroutine MPI_Ireduce_scatter_block_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ireduce_scatter_block_c( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ireduce_scatter_block_c

  subroutine MPI_Irsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Irsend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Irsend

  subroutine MPI_Irsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Irsend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Irsend_c

  subroutine MPI_Is_thread_main( &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Is_thread_main( &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Is_thread_main

  subroutine MPI_Iscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscan( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscan

  subroutine MPI_Iscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscan_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscan_c

  subroutine MPI_Iscatter( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscatter( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscatter

  subroutine MPI_Iscatter_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscatter_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscatter_c

  subroutine MPI_Iscatterv( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscatterv( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscatterv

  subroutine MPI_Iscatterv_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Iscatterv_c( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Iscatterv_c

  subroutine MPI_Isend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isend

  subroutine MPI_Isend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isend_c

  subroutine MPI_Isendrecv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isendrecv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      dest, &
      sendtag, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isendrecv

  subroutine MPI_Isendrecv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isendrecv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      dest, &
      sendtag, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isendrecv_c

  subroutine MPI_Isendrecv_replace( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isendrecv_replace( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      sendtag, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isendrecv_replace

  subroutine MPI_Isendrecv_replace_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Isendrecv_replace_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      sendtag, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Isendrecv_replace_c

  subroutine MPI_Issend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Issend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Issend

  subroutine MPI_Issend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Issend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Issend_c

  subroutine MPI_Keyval_create( &
    copy_fn, &
    delete_fn, &
    keyval, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Copy_function) :: copy_fn
    procedure(MPI_Delete_function) :: delete_fn
    integer, intent(out) :: keyval
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Keyval_create( &
      copy_fn, &
      delete_fn, &
      keyval, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Keyval_create

  subroutine MPI_Keyval_free( &
    keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(inout) :: keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Keyval_free( &
      keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Keyval_free

  subroutine MPI_Lookup_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: service_name
    type(MPI_Info), intent(in) :: info
    character*(MPI_MAX_PORT_NAME), intent(out) :: port_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Lookup_name( &
      service_name, &
      info%MPI_VAL, &
      port_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Lookup_name

  subroutine MPI_Mprobe( &
    source, &
    tag, &
    comm, &
    message, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Message), intent(out) :: message
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Mprobe( &
      source, &
      tag, &
      comm%MPI_VAL, &
      message%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Mprobe

  subroutine MPI_Mrecv( &
    buf, &
    count, &
    datatype, &
    message, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Message), intent(inout) :: message
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Mrecv( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      message%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Mrecv

  subroutine MPI_Mrecv_c( &
    buf, &
    count, &
    datatype, &
    message, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Message), intent(inout) :: message
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Mrecv_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      message%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Mrecv_c

  subroutine MPI_Neighbor_allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgather( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgather

  subroutine MPI_Neighbor_allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgather_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgather_c

  subroutine MPI_Neighbor_allgather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgather_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgather_init

  subroutine MPI_Neighbor_allgather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgather_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgather_init_c

  subroutine MPI_Neighbor_allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgatherv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgatherv

  subroutine MPI_Neighbor_allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgatherv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgatherv_c

  subroutine MPI_Neighbor_allgatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgatherv_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgatherv_init

  subroutine MPI_Neighbor_allgatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_allgatherv_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      displs, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_allgatherv_init_c

  subroutine MPI_Neighbor_alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoall( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoall

  subroutine MPI_Neighbor_alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoall_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoall_c

  subroutine MPI_Neighbor_alltoall_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoall_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoall_init

  subroutine MPI_Neighbor_alltoall_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoall_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoall_init_c

  subroutine MPI_Neighbor_alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallv( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallv

  subroutine MPI_Neighbor_alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallv_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallv_c

  subroutine MPI_Neighbor_alltoallv_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer, intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallv_init( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallv_init

  subroutine MPI_Neighbor_alltoallv_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallv_init_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtype%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallv_init_c

  subroutine MPI_Neighbor_alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallw( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallw

  subroutine MPI_Neighbor_alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallw_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallw_c

  subroutine MPI_Neighbor_alltoallw_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallw_init( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallw_init

  subroutine MPI_Neighbor_alltoallw_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: sdispls(*)
    type(MPI_Datatype), intent(in) :: sendtypes(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: rdispls(*)
    type(MPI_Datatype), intent(in) :: recvtypes(*)
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Neighbor_alltoallw_init_c( &
      sendbuf, &
      sendcounts, &
      sdispls, &
      sendtypes%MPI_VAL, &
      recvbuf, &
      recvcounts, &
      rdispls, &
      recvtypes%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Neighbor_alltoallw_init_c

  subroutine MPI_Op_commutative( &
    op, &
    commute, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Op), intent(in) :: op
    logical, intent(out) :: commute
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Op_commutative( &
      op%MPI_VAL, &
      commute, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Op_commutative

  subroutine MPI_Op_create( &
    user_fn, &
    commute, &
    op, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_User_function) :: user_fn
    logical, intent(in) :: commute
    type(MPI_Op), intent(out) :: op
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Op_create( &
      user_fn, &
      commute, &
      op%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Op_create

  subroutine MPI_Op_create_c( &
    user_fn, &
    commute, &
    op, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_User_function_c) :: user_fn
    logical, intent(in) :: commute
    type(MPI_Op), intent(out) :: op
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Op_create_c( &
      user_fn, &
      commute, &
      op%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Op_create_c

  subroutine MPI_Op_free( &
    op, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Op), intent(inout) :: op
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Op_free( &
      op%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Op_free

  subroutine MPI_Open_port( &
    info, &
    port_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    character*(MPI_MAX_PORT_NAME), intent(out) :: port_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Open_port( &
      info%MPI_VAL, &
      port_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Open_port

  subroutine MPI_Pack( &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer, intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer, intent(in) :: outsize
    integer, intent(inout) :: position
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack( &
      inbuf, &
      incount, &
      datatype%MPI_VAL, &
      outbuf, &
      outsize, &
      position, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack

  subroutine MPI_Pack_c( &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: outsize
    integer(MPI_COUNT_KIND), intent(inout) :: position
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_c( &
      inbuf, &
      incount, &
      datatype%MPI_VAL, &
      outbuf, &
      outsize, &
      position, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_c

  subroutine MPI_Pack_external( &
    datarep, &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer, intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: outsize
    integer(MPI_ADDRESS_KIND), intent(inout) :: position
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_external( &
      datarep, &
      inbuf, &
      incount, &
      datatype%MPI_VAL, &
      outbuf, &
      outsize, &
      position, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_external

  subroutine MPI_Pack_external_c( &
    datarep, &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: outsize
    integer(MPI_COUNT_KIND), intent(inout) :: position
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_external_c( &
      datarep, &
      inbuf, &
      incount, &
      datatype%MPI_VAL, &
      outbuf, &
      outsize, &
      position, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_external_c

  subroutine MPI_Pack_external_size( &
    datarep, &
    incount, &
    datatype, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    integer, intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_ADDRESS_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_external_size( &
      datarep, &
      incount, &
      datatype%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_external_size

  subroutine MPI_Pack_external_size_c( &
    datarep, &
    incount, &
    datatype, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    integer(MPI_COUNT_KIND), intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_external_size_c( &
      datarep, &
      incount, &
      datatype%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_external_size_c

  subroutine MPI_Pack_size( &
    incount, &
    datatype, &
    comm, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_size( &
      incount, &
      datatype%MPI_VAL, &
      comm%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_size

  subroutine MPI_Pack_size_c( &
    incount, &
    datatype, &
    comm, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: incount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pack_size_c( &
      incount, &
      datatype%MPI_VAL, &
      comm%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pack_size_c

  subroutine MPI_Parrived( &
    request, &
    partition, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(in) :: request
    integer, intent(in) :: partition
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Parrived( &
      request%MPI_VAL, &
      partition, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Parrived

  subroutine MPI_Pready( &
    partition, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: partition
    type(MPI_Request), intent(in) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pready( &
      partition, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pready

  subroutine MPI_Pready_list( &
    length, &
    array_of_partitions, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: length
    integer, intent(in) :: array_of_partitions(length)
    type(MPI_Request), intent(in) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pready_list( &
      length, &
      array_of_partitions, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pready_list

  subroutine MPI_Pready_range( &
    partition_low, &
    partition_high, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: partition_low
    integer, intent(in) :: partition_high
    type(MPI_Request), intent(in) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Pready_range( &
      partition_low, &
      partition_high, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Pready_range

  subroutine MPI_Precv_init( &
    buf, &
    partitions, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: partitions
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Precv_init( &
      buf, &
      partitions, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Precv_init

  subroutine MPI_Probe( &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Probe( &
      source, &
      tag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Probe

  subroutine MPI_Psend_init( &
    buf, &
    partitions, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: partitions
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Psend_init( &
      buf, &
      partitions, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Psend_init

  subroutine MPI_Publish_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: service_name
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: port_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Publish_name( &
      service_name, &
      info%MPI_VAL, &
      port_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Publish_name

  subroutine MPI_Put( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Put( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Put

  subroutine MPI_Put_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Put_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Put_c

  subroutine MPI_Query_thread( &
    provided, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(out) :: provided
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Query_thread( &
      provided, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Query_thread

  subroutine MPI_Raccumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Raccumulate( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Raccumulate

  subroutine MPI_Raccumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Raccumulate_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Raccumulate_c

  subroutine MPI_Recv( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Recv( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Recv

  subroutine MPI_Recv_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Recv_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Recv_c

  subroutine MPI_Recv_init( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Recv_init( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Recv_init

  subroutine MPI_Recv_init_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: source
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Recv_init_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      source, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Recv_init_c

  subroutine MPI_Reduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce

  subroutine MPI_Reduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_c

  subroutine MPI_Reduce_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_init( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_init

  subroutine MPI_Reduce_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_init_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_init_c

  subroutine MPI_Reduce_local( &
    inbuf, &
    inoutbuf, &
    count, &
    datatype, &
    op, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    !gcc$ attributes no_arg_check :: inoutbuf
    integer :: inoutbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_local( &
      inbuf, &
      inoutbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_local

  subroutine MPI_Reduce_local_c( &
    inbuf, &
    inoutbuf, &
    count, &
    datatype, &
    op, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    !gcc$ attributes no_arg_check :: inoutbuf
    integer :: inoutbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_local_c( &
      inbuf, &
      inoutbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_local_c

  subroutine MPI_Reduce_scatter( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter

  subroutine MPI_Reduce_scatter_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_c( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_c

  subroutine MPI_Reduce_scatter_block( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_block( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_block

  subroutine MPI_Reduce_scatter_block_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_block_c( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_block_c

  subroutine MPI_Reduce_scatter_block_init( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_block_init( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_block_init

  subroutine MPI_Reduce_scatter_block_init_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_block_init_c( &
      sendbuf, &
      recvbuf, &
      recvcount, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_block_init_c

  subroutine MPI_Reduce_scatter_init( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_init( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_init

  subroutine MPI_Reduce_scatter_init_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcounts(*)
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Reduce_scatter_init_c( &
      sendbuf, &
      recvbuf, &
      recvcounts, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Reduce_scatter_init_c

  subroutine MPI_Register_datarep( &
    datarep, &
    read_conversion_fn, &
    write_conversion_fn, &
    dtype_file_extent_fn, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    procedure(MPI_Datarep_conversion_function) :: read_conversion_fn
    procedure(MPI_Datarep_conversion_function) :: write_conversion_fn
    procedure(MPI_Datarep_extent_function) :: dtype_file_extent_fn
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Register_datarep( &
      datarep, &
      read_conversion_fn, &
      write_conversion_fn, &
      dtype_file_extent_fn, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Register_datarep

  subroutine MPI_Register_datarep_c( &
    datarep, &
    read_conversion_fn, &
    write_conversion_fn, &
    dtype_file_extent_fn, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    procedure(MPI_Datarep_conversion_function_c) :: read_conversion_fn
    procedure(MPI_Datarep_conversion_function_c) :: write_conversion_fn
    procedure(MPI_Datarep_extent_function) :: dtype_file_extent_fn
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Register_datarep_c( &
      datarep, &
      read_conversion_fn, &
      write_conversion_fn, &
      dtype_file_extent_fn, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Register_datarep_c

  subroutine MPI_Remove_error_class( &
    errorclass, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorclass
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Remove_error_class( &
      errorclass, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Remove_error_class

  subroutine MPI_Remove_error_code( &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Remove_error_code( &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Remove_error_code

  subroutine MPI_Remove_error_string( &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Remove_error_string( &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Remove_error_string

  subroutine MPI_Request_free( &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(inout) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Request_free( &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Request_free

  subroutine MPI_Request_get_status( &
    request, &
    flag, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(in) :: request
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Request_get_status( &
      request%MPI_VAL, &
      flag, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Request_get_status

  subroutine MPI_Request_get_status_all( &
    count, &
    array_of_requests, &
    flag, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(in) :: array_of_requests(*)
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Request_get_status_all( &
      count, &
      array_of_requests%MPI_VAL, &
      flag, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Request_get_status_all

  subroutine MPI_Request_get_status_any( &
    count, &
    array_of_requests, &
    index, &
    flag, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(in) :: array_of_requests(*)
    integer, intent(out) :: index
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Request_get_status_any( &
      count, &
      array_of_requests%MPI_VAL, &
      index, &
      flag, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Request_get_status_any

  subroutine MPI_Request_get_status_some( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: incount
    type(MPI_Request), intent(in) :: array_of_requests(*)
    integer, intent(out) :: outcount
    integer, intent(out) :: array_of_indices(*)
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Request_get_status_some( &
      incount, &
      array_of_requests%MPI_VAL, &
      outcount, &
      array_of_indices, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Request_get_status_some

  subroutine MPI_Rget( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rget( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rget

  subroutine MPI_Rget_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rget_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rget_c

  subroutine MPI_Rget_accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer, intent(in) :: result_count
    type(MPI_Datatype), intent(in) :: result_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rget_accumulate( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      result_addr, &
      result_count, &
      result_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rget_accumulate

  subroutine MPI_Rget_accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: result_count
    type(MPI_Datatype), intent(in) :: result_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rget_accumulate_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      result_addr, &
      result_count, &
      result_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      op%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rget_accumulate_c

  subroutine MPI_Rput( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer, intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer, intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rput( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rput

  subroutine MPI_Rput_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND), intent(in) :: origin_count
    type(MPI_Datatype), intent(in) :: origin_datatype
    integer, intent(in) :: target_rank
    integer, intent(in) :: target_disp
    integer(MPI_COUNT_KIND), intent(in) :: target_count
    type(MPI_Datatype), intent(in) :: target_datatype
    type(MPI_Win), intent(in) :: win
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rput_c( &
      origin_addr, &
      origin_count, &
      origin_datatype%MPI_VAL, &
      target_rank, &
      target_disp, &
      target_count, &
      target_datatype%MPI_VAL, &
      win%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rput_c

  subroutine MPI_Rsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rsend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rsend

  subroutine MPI_Rsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rsend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rsend_c

  subroutine MPI_Rsend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rsend_init( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rsend_init

  subroutine MPI_Rsend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Rsend_init_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Rsend_init_c

  subroutine MPI_Scan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scan( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scan

  subroutine MPI_Scan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scan_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scan_c

  subroutine MPI_Scan_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scan_init( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scan_init

  subroutine MPI_Scan_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Op), intent(in) :: op
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scan_init_c( &
      sendbuf, &
      recvbuf, &
      count, &
      datatype%MPI_VAL, &
      op%MPI_VAL, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scan_init_c

  subroutine MPI_Scatter( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatter( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatter

  subroutine MPI_Scatter_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatter_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatter_c

  subroutine MPI_Scatter_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatter_init( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatter_init

  subroutine MPI_Scatter_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatter_init_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatter_init_c

  subroutine MPI_Scatterv( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatterv( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatterv

  subroutine MPI_Scatterv_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatterv_c( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatterv_c

  subroutine MPI_Scatterv_init( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcounts(*)
    integer, intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatterv_init( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatterv_init

  subroutine MPI_Scatterv_init_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: displs(*)
    type(MPI_Datatype), intent(in) :: sendtype
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: root
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Info), intent(in) :: info
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Scatterv_init_c( &
      sendbuf, &
      sendcounts, &
      displs, &
      sendtype%MPI_VAL, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      root, &
      comm%MPI_VAL, &
      info%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Scatterv_init_c

  subroutine MPI_Send( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Send( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Send

  subroutine MPI_Send_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Send_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Send_c

  subroutine MPI_Send_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Send_init( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Send_init

  subroutine MPI_Send_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Send_init_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Send_init_c

  subroutine MPI_Sendrecv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer, intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer, intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Sendrecv( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      dest, &
      sendtag, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Sendrecv

  subroutine MPI_Sendrecv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: sendcount
    type(MPI_Datatype), intent(in) :: sendtype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: recvcount
    type(MPI_Datatype), intent(in) :: recvtype
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Sendrecv_c( &
      sendbuf, &
      sendcount, &
      sendtype%MPI_VAL, &
      dest, &
      sendtag, &
      recvbuf, &
      recvcount, &
      recvtype%MPI_VAL, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Sendrecv_c

  subroutine MPI_Sendrecv_replace( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Sendrecv_replace( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      sendtag, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Sendrecv_replace

  subroutine MPI_Sendrecv_replace_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: sendtag
    integer, intent(in) :: source
    integer, intent(in) :: recvtag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Sendrecv_replace_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      sendtag, &
      source, &
      recvtag, &
      comm%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Sendrecv_replace_c

  subroutine MPI_Session_attach_buffer( &
    session, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer, intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_attach_buffer( &
      session%MPI_VAL, &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_attach_buffer

  subroutine MPI_Session_attach_buffer_c( &
    session, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_attach_buffer_c( &
      session%MPI_VAL, &
      buffer, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_attach_buffer_c

  subroutine MPI_Session_call_errhandler( &
    session, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_call_errhandler( &
      session%MPI_VAL, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_call_errhandler

  subroutine MPI_Session_create_errhandler( &
    session_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Session_errhandler_function) :: session_errhandler_fn
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_create_errhandler( &
      session_errhandler_fn, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_create_errhandler

  subroutine MPI_Session_detach_buffer( &
    session, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_detach_buffer( &
      session%MPI_VAL, &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_detach_buffer

  subroutine MPI_Session_detach_buffer_c( &
    session, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    integer(MPI_ADDRESS_KIND), intent(out) :: buffer_addr
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_detach_buffer_c( &
      session%MPI_VAL, &
      buffer_addr, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_detach_buffer_c

  subroutine MPI_Session_finalize( &
    session, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(inout) :: session
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_finalize( &
      session%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_finalize

  subroutine MPI_Session_flush_buffer( &
    session, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_flush_buffer( &
      session%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_flush_buffer

  subroutine MPI_Session_get_errhandler( &
    session, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_get_errhandler( &
      session%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_get_errhandler

  subroutine MPI_Session_get_info( &
    session, &
    info_used, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Info), intent(out) :: info_used
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_get_info( &
      session%MPI_VAL, &
      info_used%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_get_info

  subroutine MPI_Session_get_nth_pset( &
    session, &
    info, &
    n, &
    pset_len, &
    pset_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Info), intent(in) :: info
    integer, intent(in) :: n
    integer, intent(inout) :: pset_len
    character*(*), intent(out) :: pset_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_get_nth_pset( &
      session%MPI_VAL, &
      info%MPI_VAL, &
      n, &
      pset_len, &
      pset_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_get_nth_pset

  subroutine MPI_Session_get_num_psets( &
    session, &
    info, &
    npset_names, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Info), intent(in) :: info
    integer, intent(out) :: npset_names
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_get_num_psets( &
      session%MPI_VAL, &
      info%MPI_VAL, &
      npset_names, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_get_num_psets

  subroutine MPI_Session_get_pset_info( &
    session, &
    pset_name, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    character*(*), intent(in) :: pset_name
    type(MPI_Info), intent(out) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_get_pset_info( &
      session%MPI_VAL, &
      pset_name, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_get_pset_info

  subroutine MPI_Session_iflush_buffer( &
    session, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_iflush_buffer( &
      session%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_iflush_buffer

  subroutine MPI_Session_init( &
    info, &
    errhandler, &
    session, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    type(MPI_Errhandler), intent(in) :: errhandler
    type(MPI_Session), intent(out) :: session
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_init( &
      info%MPI_VAL, &
      errhandler%MPI_VAL, &
      session%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_init

  subroutine MPI_Session_set_errhandler( &
    session, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Session), intent(in) :: session
    type(MPI_Errhandler), intent(in) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Session_set_errhandler( &
      session%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Session_set_errhandler

  subroutine MPI_Ssend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ssend( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ssend

  subroutine MPI_Ssend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ssend_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ssend_c

  subroutine MPI_Ssend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ssend_init( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ssend_init

  subroutine MPI_Ssend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: dest
    integer, intent(in) :: tag
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Request), intent(out) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Ssend_init_c( &
      buf, &
      count, &
      datatype%MPI_VAL, &
      dest, &
      tag, &
      comm%MPI_VAL, &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Ssend_init_c

  subroutine MPI_Start( &
    request, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(inout) :: request
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Start( &
      request%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Start

  subroutine MPI_Startall( &
    count, &
    array_of_requests, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Startall( &
      count, &
      array_of_requests%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Startall

  subroutine MPI_Status_get_error( &
    status, &
    err, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    integer, intent(out) :: err
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_get_error( &
      status%MPI_VAL, &
      err, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_get_error

  subroutine MPI_Status_get_source( &
    status, &
    source, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    integer, intent(out) :: source
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_get_source( &
      status%MPI_VAL, &
      source, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_get_source

  subroutine MPI_Status_get_tag( &
    status, &
    tag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    integer, intent(out) :: tag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_get_tag( &
      status%MPI_VAL, &
      tag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_get_tag

  subroutine MPI_Status_set_cancelled( &
    status, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    logical, intent(in) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_cancelled( &
      status%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_cancelled

  subroutine MPI_Status_set_elements( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_elements( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_elements

  subroutine MPI_Status_set_elements_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_elements_c( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_elements_c

  subroutine MPI_Status_set_elements_x( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_elements_x( &
      status%MPI_VAL, &
      datatype%MPI_VAL, &
      count, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_elements_x

  subroutine MPI_Status_set_error( &
    status, &
    err, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    integer, intent(in) :: err
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_error( &
      status%MPI_VAL, &
      err, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_error

  subroutine MPI_Status_set_source( &
    status, &
    source, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    integer, intent(in) :: source
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_source( &
      status%MPI_VAL, &
      source, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_source

  subroutine MPI_Status_set_tag( &
    status, &
    tag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(inout) :: status
    integer, intent(in) :: tag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Status_set_tag( &
      status%MPI_VAL, &
      tag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Status_set_tag

  subroutine MPI_Test( &
    request, &
    flag, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(inout) :: request
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Test( &
      request%MPI_VAL, &
      flag, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Test

  subroutine MPI_Test_cancelled( &
    status, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Status), intent(in) :: status
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Test_cancelled( &
      status%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Test_cancelled

  subroutine MPI_Testall( &
    count, &
    array_of_requests, &
    flag, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Testall( &
      count, &
      array_of_requests%MPI_VAL, &
      flag, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Testall

  subroutine MPI_Testany( &
    count, &
    array_of_requests, &
    index, &
    flag, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    integer, intent(out) :: index
    logical, intent(out) :: flag
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Testany( &
      count, &
      array_of_requests%MPI_VAL, &
      index, &
      flag, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Testany

  subroutine MPI_Testsome( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: incount
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    integer, intent(out) :: outcount
    integer, intent(out) :: array_of_indices(*)
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Testsome( &
      incount, &
      array_of_requests%MPI_VAL, &
      outcount, &
      array_of_indices, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Testsome

  subroutine MPI_Topo_test( &
    comm, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Topo_test( &
      comm%MPI_VAL, &
      status, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Topo_test

  subroutine MPI_Type_commit( &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(inout) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_commit( &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_commit

  subroutine MPI_Type_contiguous( &
    count, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_contiguous( &
      count, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_contiguous

  subroutine MPI_Type_contiguous_c( &
    count, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_contiguous_c( &
      count, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_contiguous_c

  subroutine MPI_Type_create_darray( &
    size, &
    rank, &
    ndims, &
    array_of_gsizes, &
    array_of_distribs, &
    array_of_dargs, &
    array_of_psizes, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: size
    integer, intent(in) :: rank
    integer, intent(in) :: ndims
    integer, intent(in) :: array_of_gsizes(ndims)
    integer, intent(in) :: array_of_distribs(ndims)
    integer, intent(in) :: array_of_dargs(ndims)
    integer, intent(in) :: array_of_psizes(ndims)
    integer, intent(in) :: order
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_darray( &
      size, &
      rank, &
      ndims, &
      array_of_gsizes, &
      array_of_distribs, &
      array_of_dargs, &
      array_of_psizes, &
      order, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_darray

  subroutine MPI_Type_create_darray_c( &
    size, &
    rank, &
    ndims, &
    array_of_gsizes, &
    array_of_distribs, &
    array_of_dargs, &
    array_of_psizes, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: size
    integer, intent(in) :: rank
    integer, intent(in) :: ndims
    integer(MPI_COUNT_KIND), intent(in) :: array_of_gsizes(ndims)
    integer, intent(in) :: array_of_distribs(ndims)
    integer, intent(in) :: array_of_dargs(ndims)
    integer, intent(in) :: array_of_psizes(ndims)
    integer, intent(in) :: order
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_darray_c( &
      size, &
      rank, &
      ndims, &
      array_of_gsizes, &
      array_of_distribs, &
      array_of_dargs, &
      array_of_psizes, &
      order, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_darray_c

  subroutine MPI_Type_create_f90_complex( &
    p, &
    r, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: p
    integer, intent(in) :: r
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_f90_complex( &
      p, &
      r, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_f90_complex

  subroutine MPI_Type_create_f90_integer( &
    r, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: r
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_f90_integer( &
      r, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_f90_integer

  subroutine MPI_Type_create_f90_real( &
    p, &
    r, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: p
    integer, intent(in) :: r
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_f90_real( &
      p, &
      r, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_f90_real

  subroutine MPI_Type_create_hindexed( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: array_of_blocklengths(count)
    integer(MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hindexed( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hindexed

  subroutine MPI_Type_create_hindexed_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hindexed_c( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hindexed_c

  subroutine MPI_Type_create_hindexed_block( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: blocklength
    integer(MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hindexed_block( &
      count, &
      blocklength, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hindexed_block

  subroutine MPI_Type_create_hindexed_block_c( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: blocklength
    integer(MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hindexed_block_c( &
      count, &
      blocklength, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hindexed_block_c

  subroutine MPI_Type_create_hvector( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: blocklength
    integer(MPI_ADDRESS_KIND), intent(in) :: stride
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hvector( &
      count, &
      blocklength, &
      stride, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hvector

  subroutine MPI_Type_create_hvector_c( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: blocklength
    integer(MPI_COUNT_KIND), intent(in) :: stride
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_hvector_c( &
      count, &
      blocklength, &
      stride, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_hvector_c

  subroutine MPI_Type_create_indexed_block( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: blocklength
    integer, intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_indexed_block( &
      count, &
      blocklength, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_indexed_block

  subroutine MPI_Type_create_indexed_block_c( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: blocklength
    integer(MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_indexed_block_c( &
      count, &
      blocklength, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_indexed_block_c

  subroutine MPI_Type_create_keyval( &
    type_copy_attr_fn, &
    type_delete_attr_fn, &
    type_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Type_copy_attr_function) :: type_copy_attr_fn
    procedure(MPI_Type_delete_attr_function) :: type_delete_attr_fn
    integer, intent(out) :: type_keyval
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_keyval( &
      type_copy_attr_fn, &
      type_delete_attr_fn, &
      type_keyval, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_keyval

  subroutine MPI_Type_create_resized( &
    oldtype, &
    lb, &
    extent, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: oldtype
    integer(MPI_ADDRESS_KIND), intent(in) :: lb
    integer(MPI_ADDRESS_KIND), intent(in) :: extent
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_resized( &
      oldtype%MPI_VAL, &
      lb, &
      extent, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_resized

  subroutine MPI_Type_create_resized_c( &
    oldtype, &
    lb, &
    extent, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: oldtype
    integer(MPI_COUNT_KIND), intent(in) :: lb
    integer(MPI_COUNT_KIND), intent(in) :: extent
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_resized_c( &
      oldtype%MPI_VAL, &
      lb, &
      extent, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_resized_c

  subroutine MPI_Type_create_struct( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    array_of_types, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: array_of_blocklengths(count)
    integer(MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: array_of_types(*)
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_struct( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      array_of_types%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_struct

  subroutine MPI_Type_create_struct_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    array_of_types, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: array_of_types(*)
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_struct_c( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      array_of_types%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_struct_c

  subroutine MPI_Type_create_subarray( &
    ndims, &
    array_of_sizes, &
    array_of_subsizes, &
    array_of_starts, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: ndims
    integer, intent(in) :: array_of_sizes(ndims)
    integer, intent(in) :: array_of_subsizes(ndims)
    integer, intent(in) :: array_of_starts(ndims)
    integer, intent(in) :: order
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_subarray( &
      ndims, &
      array_of_sizes, &
      array_of_subsizes, &
      array_of_starts, &
      order, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_subarray

  subroutine MPI_Type_create_subarray_c( &
    ndims, &
    array_of_sizes, &
    array_of_subsizes, &
    array_of_starts, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: ndims
    integer(MPI_COUNT_KIND), intent(in) :: array_of_sizes(ndims)
    integer(MPI_COUNT_KIND), intent(in) :: array_of_subsizes(ndims)
    integer(MPI_COUNT_KIND), intent(in) :: array_of_starts(ndims)
    integer, intent(in) :: order
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_create_subarray_c( &
      ndims, &
      array_of_sizes, &
      array_of_subsizes, &
      array_of_starts, &
      order, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_create_subarray_c

  subroutine MPI_Type_delete_attr( &
    datatype, &
    type_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: type_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_delete_attr( &
      datatype%MPI_VAL, &
      type_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_delete_attr

  subroutine MPI_Type_dup( &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_dup( &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_dup

  subroutine MPI_Type_free( &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(inout) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_free( &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_free

  subroutine MPI_Type_free_keyval( &
    type_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(inout) :: type_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_free_keyval( &
      type_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_free_keyval

  subroutine MPI_Type_get_attr( &
    datatype, &
    type_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: type_keyval
    integer, intent(out) :: attribute_val
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_attr( &
      datatype%MPI_VAL, &
      type_keyval, &
      attribute_val, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_attr

  subroutine MPI_Type_get_contents( &
    datatype, &
    max_integers, &
    max_addresses, &
    max_datatypes, &
    array_of_integers, &
    array_of_addresses, &
    array_of_datatypes, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: max_integers
    integer, intent(in) :: max_addresses
    integer, intent(in) :: max_datatypes
    integer, intent(out) :: array_of_integers(max_integers)
    integer(MPI_ADDRESS_KIND), intent(out) :: array_of_addresses(max_addresses)
    type(MPI_Datatype), intent(out) :: array_of_datatypes(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_contents( &
      datatype%MPI_VAL, &
      max_integers, &
      max_addresses, &
      max_datatypes, &
      array_of_integers, &
      array_of_addresses, &
      array_of_datatypes%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_contents

  subroutine MPI_Type_get_contents_c( &
    datatype, &
    max_integers, &
    max_addresses, &
    max_large_counts, &
    max_datatypes, &
    array_of_integers, &
    array_of_addresses, &
    array_of_large_counts, &
    array_of_datatypes, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(in) :: max_integers
    integer(MPI_COUNT_KIND), intent(in) :: max_addresses
    integer(MPI_COUNT_KIND), intent(in) :: max_large_counts
    integer(MPI_COUNT_KIND), intent(in) :: max_datatypes
    integer, intent(out) :: array_of_integers(max_integers)
    integer(MPI_ADDRESS_KIND), intent(out) :: array_of_addresses(max_addresses)
    integer(MPI_COUNT_KIND), intent(out) :: array_of_large_counts(max_large_counts)
    type(MPI_Datatype), intent(out) :: array_of_datatypes(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_contents_c( &
      datatype%MPI_VAL, &
      max_integers, &
      max_addresses, &
      max_large_counts, &
      max_datatypes, &
      array_of_integers, &
      array_of_addresses, &
      array_of_large_counts, &
      array_of_datatypes%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_contents_c

  subroutine MPI_Type_get_envelope( &
    datatype, &
    num_integers, &
    num_addresses, &
    num_datatypes, &
    combiner, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out) :: num_integers
    integer, intent(out) :: num_addresses
    integer, intent(out) :: num_datatypes
    integer, intent(out) :: combiner
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_envelope( &
      datatype%MPI_VAL, &
      num_integers, &
      num_addresses, &
      num_datatypes, &
      combiner, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_envelope

  subroutine MPI_Type_get_envelope_c( &
    datatype, &
    num_integers, &
    num_addresses, &
    num_large_counts, &
    num_datatypes, &
    combiner, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: num_integers
    integer(MPI_COUNT_KIND), intent(out) :: num_addresses
    integer(MPI_COUNT_KIND), intent(out) :: num_large_counts
    integer(MPI_COUNT_KIND), intent(out) :: num_datatypes
    integer, intent(out) :: combiner
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_envelope_c( &
      datatype%MPI_VAL, &
      num_integers, &
      num_addresses, &
      num_large_counts, &
      num_datatypes, &
      combiner, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_envelope_c

  subroutine MPI_Type_get_extent( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_ADDRESS_KIND), intent(out) :: lb
    integer(MPI_ADDRESS_KIND), intent(out) :: extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_extent( &
      datatype%MPI_VAL, &
      lb, &
      extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_extent

  subroutine MPI_Type_get_extent_c( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: lb
    integer(MPI_COUNT_KIND), intent(out) :: extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_extent_c( &
      datatype%MPI_VAL, &
      lb, &
      extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_extent_c

  subroutine MPI_Type_get_extent_x( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: lb
    integer(MPI_COUNT_KIND), intent(out) :: extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_extent_x( &
      datatype%MPI_VAL, &
      lb, &
      extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_extent_x

  subroutine MPI_Type_get_name( &
    datatype, &
    type_name, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    character*(MPI_MAX_OBJECT_NAME), intent(out) :: type_name
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_name( &
      datatype%MPI_VAL, &
      type_name, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_name

  subroutine MPI_Type_get_true_extent( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_ADDRESS_KIND), intent(out) :: true_lb
    integer(MPI_ADDRESS_KIND), intent(out) :: true_extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_true_extent( &
      datatype%MPI_VAL, &
      true_lb, &
      true_extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_true_extent

  subroutine MPI_Type_get_true_extent_c( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: true_lb
    integer(MPI_COUNT_KIND), intent(out) :: true_extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_true_extent_c( &
      datatype%MPI_VAL, &
      true_lb, &
      true_extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_true_extent_c

  subroutine MPI_Type_get_true_extent_x( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: true_lb
    integer(MPI_COUNT_KIND), intent(out) :: true_extent
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_true_extent_x( &
      datatype%MPI_VAL, &
      true_lb, &
      true_extent, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_true_extent_x

  subroutine MPI_Type_get_value_index( &
    value_type, &
    index_type, &
    pair_type, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: value_type
    type(MPI_Datatype), intent(in) :: index_type
    type(MPI_Datatype), intent(out) :: pair_type
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_get_value_index( &
      value_type%MPI_VAL, &
      index_type%MPI_VAL, &
      pair_type%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_get_value_index

  subroutine MPI_Type_indexed( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: array_of_blocklengths(count)
    integer, intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_indexed( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_indexed

  subroutine MPI_Type_indexed_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_indexed_c( &
      count, &
      array_of_blocklengths, &
      array_of_displacements, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_indexed_c

  subroutine MPI_Type_match_size( &
    typeclass, &
    size, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: typeclass
    integer, intent(in) :: size
    type(MPI_Datatype), intent(out) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_match_size( &
      typeclass, &
      size, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_match_size

  subroutine MPI_Type_set_attr( &
    datatype, &
    type_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(in) :: type_keyval
    integer, intent(in) :: attribute_val
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_set_attr( &
      datatype%MPI_VAL, &
      type_keyval, &
      attribute_val, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_set_attr

  subroutine MPI_Type_set_name( &
    datatype, &
    type_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    character*(*), intent(in) :: type_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_set_name( &
      datatype%MPI_VAL, &
      type_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_set_name

  subroutine MPI_Type_size( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_size( &
      datatype%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_size

  subroutine MPI_Type_size_c( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_size_c( &
      datatype%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_size_c

  subroutine MPI_Type_size_x( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Datatype), intent(in) :: datatype
    integer(MPI_COUNT_KIND), intent(out) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_size_x( &
      datatype%MPI_VAL, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_size_x

  subroutine MPI_Type_vector( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    integer, intent(in) :: blocklength
    integer, intent(in) :: stride
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_vector( &
      count, &
      blocklength, &
      stride, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_vector

  subroutine MPI_Type_vector_c( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_COUNT_KIND), intent(in) :: count
    integer(MPI_COUNT_KIND), intent(in) :: blocklength
    integer(MPI_COUNT_KIND), intent(in) :: stride
    type(MPI_Datatype), intent(in) :: oldtype
    type(MPI_Datatype), intent(out) :: newtype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Type_vector_c( &
      count, &
      blocklength, &
      stride, &
      oldtype%MPI_VAL, &
      newtype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Type_vector_c

  subroutine MPI_Unpack( &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer, intent(in) :: insize
    integer, intent(inout) :: position
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer, intent(in) :: outcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Unpack( &
      inbuf, &
      insize, &
      position, &
      outbuf, &
      outcount, &
      datatype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Unpack

  subroutine MPI_Unpack_c( &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    comm, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: insize
    integer(MPI_COUNT_KIND), intent(inout) :: position
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: outcount
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Unpack_c( &
      inbuf, &
      insize, &
      position, &
      outbuf, &
      outcount, &
      datatype%MPI_VAL, &
      comm%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Unpack_c

  subroutine MPI_Unpack_external( &
    datarep, &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: insize
    integer(MPI_ADDRESS_KIND), intent(inout) :: position
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer, intent(in) :: outcount
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Unpack_external( &
      datarep, &
      inbuf, &
      insize, &
      position, &
      outbuf, &
      outcount, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Unpack_external

  subroutine MPI_Unpack_external_c( &
    datarep, &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: datarep
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: insize
    integer(MPI_COUNT_KIND), intent(inout) :: position
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND), intent(in) :: outcount
    type(MPI_Datatype), intent(in) :: datatype
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Unpack_external_c( &
      datarep, &
      inbuf, &
      insize, &
      position, &
      outbuf, &
      outcount, &
      datatype%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Unpack_external_c

  subroutine MPI_Unpublish_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    character*(*), intent(in) :: service_name
    type(MPI_Info), intent(in) :: info
    character*(*), intent(in) :: port_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Unpublish_name( &
      service_name, &
      info%MPI_VAL, &
      port_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Unpublish_name

  subroutine MPI_Wait( &
    request, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Request), intent(inout) :: request
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Wait( &
      request%MPI_VAL, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Wait

  subroutine MPI_Waitall( &
    count, &
    array_of_requests, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Waitall( &
      count, &
      array_of_requests%MPI_VAL, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Waitall

  subroutine MPI_Waitany( &
    count, &
    array_of_requests, &
    index, &
    status, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: count
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    integer, intent(out) :: index
    type(MPI_Status), intent(out) :: status
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Waitany( &
      count, &
      array_of_requests%MPI_VAL, &
      index, &
      status%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Waitany

  subroutine MPI_Waitsome( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: incount
    type(MPI_Request), intent(inout) :: array_of_requests(*)
    integer, intent(out) :: outcount
    integer, intent(out) :: array_of_indices(*)
    type(MPI_Status), intent(out) :: array_of_statuses
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Waitsome( &
      incount, &
      array_of_requests%MPI_VAL, &
      outcount, &
      array_of_indices, &
      array_of_statuses%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Waitsome

  subroutine MPI_Win_allocate( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer, intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_allocate( &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      baseptr, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_allocate

  subroutine MPI_Win_allocate_c( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer(MPI_ADDRESS_KIND), intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_allocate_c( &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      baseptr, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_allocate_c

  subroutine MPI_Win_allocate_shared( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer, intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_allocate_shared( &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      baseptr, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_allocate_shared

  subroutine MPI_Win_allocate_shared_c( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer(MPI_ADDRESS_KIND), intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_allocate_shared_c( &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      baseptr, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_allocate_shared_c

  subroutine MPI_Win_attach( &
    win, &
    base, &
    size, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_attach( &
      win%MPI_VAL, &
      base, &
      size, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_attach

  subroutine MPI_Win_call_errhandler( &
    win, &
    errorcode, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: errorcode
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_call_errhandler( &
      win%MPI_VAL, &
      errorcode, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_call_errhandler

  subroutine MPI_Win_complete( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_complete( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_complete

  subroutine MPI_Win_create( &
    base, &
    size, &
    disp_unit, &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer, intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_create( &
      base, &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_create

  subroutine MPI_Win_create_c( &
    base, &
    size, &
    disp_unit, &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND), intent(in) :: size
    integer(MPI_ADDRESS_KIND), intent(in) :: disp_unit
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_create_c( &
      base, &
      size, &
      disp_unit, &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_create_c

  subroutine MPI_Win_create_dynamic( &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Info), intent(in) :: info
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Win), intent(out) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_create_dynamic( &
      info%MPI_VAL, &
      comm%MPI_VAL, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_create_dynamic

  subroutine MPI_Win_create_errhandler( &
    win_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Win_errhandler_function) :: win_errhandler_fn
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_create_errhandler( &
      win_errhandler_fn, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_create_errhandler

  subroutine MPI_Win_create_keyval( &
    win_copy_attr_fn, &
    win_delete_attr_fn, &
    win_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    procedure(MPI_Win_copy_attr_function) :: win_copy_attr_fn
    procedure(MPI_Win_delete_attr_function) :: win_delete_attr_fn
    integer, intent(out) :: win_keyval
    integer, intent(in) :: extra_state
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_create_keyval( &
      win_copy_attr_fn, &
      win_delete_attr_fn, &
      win_keyval, &
      extra_state, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_create_keyval

  subroutine MPI_Win_delete_attr( &
    win, &
    win_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: win_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_delete_attr( &
      win%MPI_VAL, &
      win_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_delete_attr

  subroutine MPI_Win_detach( &
    win, &
    base, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_detach( &
      win%MPI_VAL, &
      base, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_detach

  subroutine MPI_Win_fence( &
    assert, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: assert
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_fence( &
      assert, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_fence

  subroutine MPI_Win_flush( &
    rank, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: rank
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_flush( &
      rank, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_flush

  subroutine MPI_Win_flush_all( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_flush_all( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_flush_all

  subroutine MPI_Win_flush_local( &
    rank, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: rank
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_flush_local( &
      rank, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_flush_local

  subroutine MPI_Win_flush_local_all( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_flush_local_all( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_flush_local_all

  subroutine MPI_Win_free( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(inout) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_free( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_free

  subroutine MPI_Win_free_keyval( &
    win_keyval, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(inout) :: win_keyval
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_free_keyval( &
      win_keyval, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_free_keyval

  subroutine MPI_Win_get_attr( &
    win, &
    win_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: win_keyval
    integer, intent(out) :: attribute_val
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_get_attr( &
      win%MPI_VAL, &
      win_keyval, &
      attribute_val, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_get_attr

  subroutine MPI_Win_get_errhandler( &
    win, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    type(MPI_Errhandler), intent(out) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_get_errhandler( &
      win%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_get_errhandler

  subroutine MPI_Win_get_group( &
    win, &
    group, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    type(MPI_Group), intent(out) :: group
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_get_group( &
      win%MPI_VAL, &
      group%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_get_group

  subroutine MPI_Win_get_info( &
    win, &
    info_used, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    type(MPI_Info), intent(out) :: info_used
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_get_info( &
      win%MPI_VAL, &
      info_used%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_get_info

  subroutine MPI_Win_get_name( &
    win, &
    win_name, &
    resultlen, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    character*(MPI_MAX_OBJECT_NAME), intent(out) :: win_name
    integer, intent(out) :: resultlen
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_get_name( &
      win%MPI_VAL, &
      win_name, &
      resultlen, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_get_name

  subroutine MPI_Win_lock( &
    lock_type, &
    rank, &
    assert, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: lock_type
    integer, intent(in) :: rank
    integer, intent(in) :: assert
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_lock( &
      lock_type, &
      rank, &
      assert, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_lock

  subroutine MPI_Win_lock_all( &
    assert, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: assert
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_lock_all( &
      assert, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_lock_all

  subroutine MPI_Win_post( &
    group, &
    assert, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: assert
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_post( &
      group%MPI_VAL, &
      assert, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_post

  subroutine MPI_Win_set_attr( &
    win, &
    win_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: win_keyval
    integer, intent(in) :: attribute_val
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_set_attr( &
      win%MPI_VAL, &
      win_keyval, &
      attribute_val, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_set_attr

  subroutine MPI_Win_set_errhandler( &
    win, &
    errhandler, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    type(MPI_Errhandler), intent(in) :: errhandler
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_set_errhandler( &
      win%MPI_VAL, &
      errhandler%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_set_errhandler

  subroutine MPI_Win_set_info( &
    win, &
    info, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    type(MPI_Info), intent(in) :: info
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_set_info( &
      win%MPI_VAL, &
      info%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_set_info

  subroutine MPI_Win_set_name( &
    win, &
    win_name, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    character*(*), intent(in) :: win_name
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_set_name( &
      win%MPI_VAL, &
      win_name, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_set_name

  subroutine MPI_Win_shared_query( &
    win, &
    rank, &
    size, &
    disp_unit, &
    baseptr, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: rank
    integer(MPI_ADDRESS_KIND), intent(out) :: size
    integer, intent(out) :: disp_unit
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_shared_query( &
      win%MPI_VAL, &
      rank, &
      size, &
      disp_unit, &
      baseptr, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_shared_query

  subroutine MPI_Win_shared_query_c( &
    win, &
    rank, &
    size, &
    disp_unit, &
    baseptr, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(in) :: rank
    integer(MPI_ADDRESS_KIND), intent(out) :: size
    integer(MPI_ADDRESS_KIND), intent(out) :: disp_unit
    integer(MPI_ADDRESS_KIND), intent(out) :: baseptr
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_shared_query_c( &
      win%MPI_VAL, &
      rank, &
      size, &
      disp_unit, &
      baseptr, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_shared_query_c

  subroutine MPI_Win_start( &
    group, &
    assert, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Group), intent(in) :: group
    integer, intent(in) :: assert
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_start( &
      group%MPI_VAL, &
      assert, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_start

  subroutine MPI_Win_sync( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_sync( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_sync

  subroutine MPI_Win_test( &
    win, &
    flag, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    logical, intent(out) :: flag
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_test( &
      win%MPI_VAL, &
      flag, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_test

  subroutine MPI_Win_unlock( &
    rank, &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    integer, intent(in) :: rank
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_unlock( &
      rank, &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_unlock

  subroutine MPI_Win_unlock_all( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_unlock_all( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_unlock_all

  subroutine MPI_Win_wait( &
    win, &
    ierror &
  )
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    type(MPI_Win), intent(in) :: win
    integer, intent(out), optional :: ierror
    integer :: tmp_ierror
    call MPIF_Win_wait( &
      win%MPI_VAL, &
      tmp_ierror &
    )
    if (present(ierror)) ierror = tmp_ierror
  end subroutine MPI_Win_wait

  function MPI_Wtick( &
  ) result(result)
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    double precision :: result
    result = MPIF_Wtick( &
    )
  end function MPI_Wtick

  function MPI_Wtime( &
  ) result(result)
    use mpi_f08_constants
    use mpi_f08_types
    implicit none
    double precision :: result
    result = MPIF_Wtime( &
    )
  end function MPI_Wtime

end module mpi_f08_functions
