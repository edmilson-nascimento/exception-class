
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
        select_value              = select_value     " selected value
      TABLES
        fields                    = fields           " internal table for transfer of the
        valuetab                  = valuetab         " internal table for transfer of the
      EXCEPTIONS
        field_not_in_ddic         = 1                " Table field not listed in the Dict
        more_then_one_selectfield = 2                " During selection, only transfer of
        no_selectfield            = 3                " No field selected for transfer
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




  
CLASS priority DEFINITION CREATE PUBLIC.

    PUBLIC SECTION.

  
    PRIVATE SECTION.
  
      TYPES:
        BEGIN OF ty_bc,
          user      TYPE zcc-bc,
          name_text TYPE adrp-name_text,
        END OF ty_bc,
        tab_bc        TYPE SORTED TABLE OF ty_bc WITH UNIQUE KEY user,
  
      METHODS get_bc_working
        IMPORTING im_list       TYPE tab_bc
        RETURNING VALUE(result) TYPE zcc-bc
        RAISING   lcx_exception.

    ENDCLASS.

CLASS priority IMPLEMENTATION.
    
ENDCLASS.
