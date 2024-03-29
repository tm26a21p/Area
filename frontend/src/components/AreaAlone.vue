<template>
    <div class="area-alone" 
    :style="{
        background: color,
    }"
    >
        <button id="close-modal" class="btn btn-dark" @click="$emit('close', null)">Close</button>
        <h1 class="m-5">{{area.name}}</h1>
        <h2 class="m-5">{{area.description}}</h2>
        <form @submit.prevent="chooseArea" id="configSpot">

            <button type="submit" id="choose-area" class="btn btn-primary choose-area m-5">Choose {{area.name}}</button>
        </form>
        <div>
        </div>
        <div class="fake-footer"
          :style="{
            'height': `calc(${fakeFooterResize}px)`
          }">
        </div>
    </div>
</template>

<script>
import { useAreaStore } from "@/store/area";

export default {
    name : "AreaAlone",
    setup() {
        const areaStore = useAreaStore();
        return {
            areaStore,
        };
    },
    props : {
        modal : Boolean,
        area : Object,
        color : String,
    },
    data() {
        return {
          config : null,
          newArea : this.area,
        };
    },
    computed : {
      fakeFooterResize() {
        return window.innerHeight - 20;
      },
      isFormFilled() {
        let config = this.config;
        if (!config)
            return true;
        for (let i = 0; i < config.length; i++) {
            let result = config[i].split(":");
            let name = result[0];
            let input = document.getElementById(name);
            if (input.value == "") {
                return false;
            }
        }
        return true;
      },
    },
    mounted() {
        this.getConfig();
        if (this.config) {
            this.createConfig();
        }
    },
    methods: {
        getAreaParams() {
            let params = "";
            // get the name of each config
            let config = this.config;
            for (let i = 0; i < config.length; i++) {
                let result = config[i].split(":");
                let name = result[0];
                params += name + ":";
                let input = document.getElementById(name);
                params += input.value + "|";
            }
            return params;
        },
        chooseArea() {
            if (this.area.config != "") {
                let params = this.getAreaParams();
                this.newArea.params = params;
            }
            this.$emit('close', this.newArea)
        },
        getConfig() {
            let pure = this.area.config;
            if (pure === "") {
                this.config = null;
                return;
            } 
            let newConfig = pure.split("|");
            this.config = newConfig;
        },
        parseName(name) {
            let newName = name.replace(/([A-Z])/g, ' $1').toLowerCase();
            newName = newName.replace(/_/g, ' ');
            return newName.charAt(0).toUpperCase() + newName.slice(1);
        },
        createConfig() {
            let config = this.config;
            let configDiv = document.getElementById("configSpot");
            for (let i = 0; i < config.length; i++) {
                let result = config[i].split(":");
                let configName = result[0];
                let name = this.parseName(configName);
                let value = result[1];
                let label = document.createElement("label");
                label.setAttribute("for", configName);
                label.innerHTML = name;
                label.classList.add("form-label");
                label.style.margin = "10px";
                label.style.fontSize = "1.5rem";
                let input = document.createElement("input");
                input.setAttribute("type", value);
                input.setAttribute("id", configName);
                input.setAttribute("required", "");
                input.classList.add("form-control");
                // add   border: 6px solid #555; border-radius: 44px;
                input.style.border = "6px solid #555";
                input.style.borderRadius = "44px";
                input.style.margin = "10px";
                input.style.fontSize = "1.5rem";
                if (i == 0) {                    
                    configDiv.prepend(input);
                    configDiv.prepend(label);
                } else {
                    configDiv.append(label);
                    configDiv.append(input);
                }
            }
            let button = document.getElementById("choose-area");
            button.remove();
            configDiv.append(button);
        }
    }
}

</script>

<style scoped>
#close-modal {
    position: absolute;
    top: 0;
    right: 0;
    margin: 20px;
}
.form-label {
    margin: 10px;
}
.form-control {
    margin: 10px;
    padding: 20px;
}
.area-alone {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    margin: 0px;
}
.choose-area {
  font-size: 2em;
  margin: 20px;
  padding: 15px 40px 15px 40px;
  border-radius: 40px;
}
#configSpot {
    font-family: "Tommy";
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
}
</style>