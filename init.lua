minetest.register_privilege(
    'student',
    {
        description = "player is affected by bulk commands targeted at students",
        give_to_singleplayer = false,
    }
)

minetest.register_privilege(
    'teacher',
    {
        description = "player can apply bulk commands targeted at students",
        give_to_singleplayer = false,
    }
)

local for_all_students = function(
    action
)
    for _, player in pairs(
        minetest.get_connected_players(
        )
    ) do
        local name = player:get_player_name(
        )
        local privs = minetest.get_player_privs(
            name
        )
        if true == privs[
            "student"
        ] then
            action(
                player,
                name
            )
        end
    end
end

minetest.register_chatcommand(
    "list_students",
    {
        description = "list student player names",
        privs = {
            teacher = true,
        },
        func = function(
            own_name,
            param
        )
            for_all_students(
                function(
                    player,
                    name
                )
                    minetest.chat_send_player(
                        own_name,
                        "EDUtest: found player " .. name
                    )
                end
            )
        end,
    }
)

minetest.register_chatcommand(
    "every_student",
    {
        description = "apply command to all student players",
        privs = {
            teacher = true,
        },
        func = function(
            own_name,
            param
        )
            for_all_students(
                function(
                    player,
                    name
                )
                    local command = string.gsub(
                        param,
                        "subject",
                        name
                    )
                    minetest.chat_send_player(
                        own_name,
                        "EDUtest: generated command " .. command
                    )
                end
            )
        end,
    }
)

minetest.register_on_joinplayer(
    function (player)
        local name = player:get_player_name(
        )
        local privs = minetest.get_player_privs(
            name
        )
        if true == privs[
            "student"
        ] then
            print(
                "EDUtest: student joined: " .. name
            )
        end
    end
)
