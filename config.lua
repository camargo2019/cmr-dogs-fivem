---- Developer by git@camargo2019

config = {}

config.keyboard = "F5"

config.model = {
    {model = "a_c_retriever", anim_name = "retriever"},
    {model = "a_c_husky", anim_name = "retriever"},
    {model = "a_c_rottweiler", anim_name = "retriever"},
    {model = "a_c_shepherd", anim_name = "retriever"},
    {model = "a_c_chop", anim_name = "retriever"},
    {model = "a_c_pug", anim_name = "pug"},
    {model = "a_c_poodle", anim_name = "pug"},
    {model = "a_c_westy", anim_name = "pug"}
}

config.dogs = {
    {
        passport = 1002,
        model = "a_c_husky",
        owners = {15, 1131, 4, 3, 2, 1, 1045}
    }
} 

config.animations = {
    {
        name = "Latir Brabo",
        id = "bark_angry",
        dict = "@amb@world_dog_barking@base", 
        anim = "base", 
        loop = false
    },
    {
        name = "Latir - Chama atenção",
        id = "barking_draws_attention",
        dict = "@amb@world_dog_barking@idle_a", 
        anim = "idle_a", 
        loop = false
    },
    {
        name = "Latir de Pé - Chama atenção",
        id = "bark_foot",
        dict = "@amb@world_dog_barking@idle_a",
        anim = "idle_b", 
        loop = false
    },
    {
        name = "Latir e girar",
        id = "bark_and_spin",
        dict = "@amb@world_dog_barking@idle_a", 
        anim = "idle_c", 
        loop = false
    },
    {
        name = "Se coçar",
        id = "scratch_yourself",
        dict = "@amb@world_dog_sitting@idle_a", 
        anim = "idle_a", 
        loop = false
    },
    {
        name = "Deitar",
        id = "throw",
        dict = "@amb@world_dog_sitting@idle_a", 
        anim = "idle_c", 
        loop = true
    }
}