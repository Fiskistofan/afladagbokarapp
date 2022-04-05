/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.models;

import java.util.ArrayList;

/**
 * Created by annalaufey on 12/21/17.
 */

public class ProfileResponse {
    private Profile profile;
    private ArrayList<Ship> ships;
    private ArrayList<Equipment> equipment;
    private ArrayList<Port> ports;
    private ArrayList<Species> fishSpecies;
    private ArrayList<Species> otherSpecies;
    private ArrayList<FishingEquipments> fishingEquipments;

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

    public ArrayList<Ship> getShips() {
        return ships;
    }

    public void setShips(ArrayList<Ship> ships) {
        this.ships = ships;
    }

    public ArrayList<Equipment> getEquipment() {
        return equipment;
    }

    public void setEquipment(ArrayList<Equipment> equipment) {
        this.equipment = equipment;
    }

    public ArrayList<Port> getPorts() {
        return ports;
    }

    public void setPorts(ArrayList<Port> ports) {
        this.ports = ports;
    }

    public ArrayList<Species> getFishSpecies() {
        return fishSpecies;
    }

    public void setFishSpecies(ArrayList<Species> fishSpecies) {
        this.fishSpecies = fishSpecies;
    }

    public ArrayList<Species> getOtherSpecies() {
        return otherSpecies;
    }

    public void setOtherSpecies(ArrayList<Species> otherSpecies) {
        this.otherSpecies = otherSpecies;
    }

    public ArrayList<FishingEquipments> getFishingEquipments() {
        return fishingEquipments;
    }

    public void setFishingEquipments(ArrayList<FishingEquipments> fishingEquipments) {
        this.fishingEquipments = fishingEquipments;
    }
}
