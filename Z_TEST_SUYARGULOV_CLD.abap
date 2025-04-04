*&---------------------------------------------------------------------*
*&  Include           Z_TEST_SUYARGULOV_CLD
*&---------------------------------------------------------------------*

CLASS lcl_app DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_data,
        bukrs    TYPE ekko-bukrs,
        banfn    TYPE eban-banfn,
        bnfpo    TYPE eban-bnfpo,
        matnr    TYPE eban-matnr,
        eb_menge TYPE eban-menge,
        ebeln    TYPE ekko-ebeln,
        ebelp    TYPE ekpo-ebelp,
        ek_menge TYPE ekpo-menge,
        belnr    TYPE rseg-belnr,
        buzei    TYPE rseg-buzei,
        rs_menge TYPE rseg-menge,
        shkzg    TYPE rseg-shkzg,
      END OF ty_data.

    DATA: gt_data TYPE TABLE OF ty_data,
          go_grid TYPE REF TO cl_salv_table.

    METHODS:
      start,
      get_data,
      show_grid,
      convert_data.

  PRIVATE SECTION.
    METHODS:
      _on_double_click
        FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column.
ENDCLASS.