-module(rohc_comp).

-export([create/2,
         compress/1]).

-include("rohc_cxt_common.hrl").

create(MaxCid, Profile) ->
    rohc_comp_context:init(MaxCid, Profile).

compress(RawPackage) ->
    Context   = rohc_comp_context:get_context(RawPackage),    
    NextState = ?cxt_profile(Context):decide_next_state(Context),

    case NextState:compress(Context, RawPackage) of
        {ok, UpdatedContext, CompressedPackage} ->            
            rohc_comp_context:put_context(UpdatedContext),
            {ok, CompressedPackage};
        {nok, _UpdatedContext, Reason} ->
            {nok, Reason}
    end.
