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

/**
 * Created by annalaufey on 1/26/18.
 */

public class Equipment {
    private int id;
    private int shipId;
    private int fishingEquipmentTypeId;
    private int numberOfBjodOnLine;
    private int numberOfHooksOnLine;
    private int numberOfNets;
    private double heightOfMoskviOnNet;
    private double sizeOfMoskviOnNet;
    private int numberOfHandEquipment;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getShipId() {
        return shipId;
    }

    public void setShipId(int shipId) {
        this.shipId = shipId;
    }

    public int getFishingEquipmentTypeId() {
        return fishingEquipmentTypeId;
    }

    public void setFishingEquipmentTypeId(int fishingEquipmentTypeId) {
        this.fishingEquipmentTypeId = fishingEquipmentTypeId;
    }

    public int getNumberOfBjodOnLine() {
        return numberOfBjodOnLine;
    }

    public void setNumberOfBjodOnLine(int numberOfBjodOnLine) {
        this.numberOfBjodOnLine = numberOfBjodOnLine;
    }

    public int getNumberOfHooksOnLine() {
        return numberOfHooksOnLine;
    }

    public void setNumberOfHooksOnLine(int numberOfHooksOnLine) {
        this.numberOfHooksOnLine = numberOfHooksOnLine;
    }

    public int getNumberOfNets() {
        return numberOfNets;
    }

    public void setNumberOfNets(int numberOfNets) {
        this.numberOfNets = numberOfNets;
    }

    public double getHeightOfMoskviOnNet() {
        return heightOfMoskviOnNet;
    }

    public void setHeightOfMoskviOnNet(double heightOfMoskviOnNet) {
        this.heightOfMoskviOnNet = heightOfMoskviOnNet;
    }

    public double getSizeOfMoskviOnNet() {
        return sizeOfMoskviOnNet;
    }

    public void setSizeOfMoskviOnNet(double sizeOfMoskviOnNet) {
        this.sizeOfMoskviOnNet = sizeOfMoskviOnNet;
    }

    public int getNumberOfHandEquipment() {
        return numberOfHandEquipment;
    }

    public void setNumberOfHandEquipment(int numberOfHandEquipment) {
        this.numberOfHandEquipment = numberOfHandEquipment;
    }
}
