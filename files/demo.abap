CLASS priority DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_bc,
        user      TYPE zcc-bc,
        name_text TYPE adrp-name_text,
      END OF ty_bc,
      tab_bc TYPE SORTED TABLE OF ty_bc WITH UNIQUE KEY user.

    METHODS get_bc_working
      IMPORTING im_list       TYPE tab_bc
      RETURNING VALUE(result) TYPE zcc-bc
      RAISING   lcx_exception.

  PRIVATE SECTION.

ENDCLASS.

CLASS priority IMPLEMENTATION.

  METHOD get_bc_working.

    DATA:
      select_value TYPE ty_bc,
      fields       TYPE STANDARD TABLE OF help_value,
      valuetab     TYPE STANDARD TABLE OF ty_bc.

    IF lines( im_list ) = 0.
      RETURN.
    ENDIF.

    fields = VALUE #( ( tabname    = 'ZCC'
                        fieldname  = 'BC'
                        selectflag = 'X' ) ).

    valuetab = VALUE #( FOR l IN im_list
                        ( user      = l-user
                          name_text = l-name_text ) ).

    CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
      IMPORTING
        select_value              = select_value
      TABLES
        fields                    = fields
        valuetab                  = valuetab
      EXCEPTIONS
        field_not_in_ddic         = 1
        more_then_one_selectfield = 2
        no_selectfield            = 3
        OTHERS                    = 4.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF select_value IS INITIAL.
      RAISE EXCEPTION TYPE lcx_exception
        EXPORTING textid = lcx_exception=>no_bc_selected.
    ENDIF.

    result = select_value-user.

  ENDMETHOD.

ENDCLASS.
