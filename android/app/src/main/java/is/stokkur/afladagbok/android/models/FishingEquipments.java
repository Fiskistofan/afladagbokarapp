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
 * Created by annalaufey on 12/13/17.
 */

public class FishingEquipments {

    static final public String HAND = "HAND";
    static final public String LINE = "LINE";
    static final public String NET = "NET";

    private int id;
    private String fishingEquipmentType;
    private String fishingEquipmentTypeName;

    public FishingEquipments(int id, String fishingEquipmentType, String fishingEquipmentTypeName) {
        this.id = id;
        this.fishingEquipmentType = fishingEquipmentType;
        this.fishingEquipmentTypeName = fishingEquipmentTypeName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return fishingEquipmentType;
    }

    public void setType(String type) {
        this.fishingEquipmentType = type;
    }

    public String getName() {
        return fishingEquipmentTypeName;
    }

    public void setName(String name) {
        this.fishingEquipmentTypeName = name;
    }

}
