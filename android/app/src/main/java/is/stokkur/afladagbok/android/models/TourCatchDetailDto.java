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
 * Created by annalaufey on 1/12/18.
 */

public class TourCatchDetailDto {
    private String landingPort;
    private String landingDate;
    private double catchSum;
    private double smallCatchSum;
    private double speciesCount;
    private double totalPulls;
    private ArrayList<FishSpeciesTotalCatch> fishSpeciesTotalCatchList;
    private ArrayList<MammalAndBirdsTotalCatch> mammalAndBirdsTotalCatchList;

    public String getLandingPort() {
        return landingPort;
    }

    public void setLandingPort(String landingPort) {
        this.landingPort = landingPort;
    }

    public String getLandingDate() {
        return landingDate;
    }

    public void setLandingDate(String landingDate) {
        this.landingDate = landingDate;
    }

    public double getCatchSum() {
        return catchSum;
    }

    public void setCatchSum(double catchSum) {
        this.catchSum = catchSum;
    }

    public double getSmallCatchSum() {
        return smallCatchSum;
    }

    public void setSmallCatchSum(double smallCatchSum) {
        this.smallCatchSum = smallCatchSum;
    }

    public double getSpeciesCount() {
        return speciesCount;
    }

    public void setSpeciesCount(double speciesCount) {
        this.speciesCount = speciesCount;
    }

    public double getTotalPulls() {
        return totalPulls;
    }

    public void setTotalPulls(double totalPulls) {
        this.totalPulls = totalPulls;
    }

    public ArrayList<FishSpeciesTotalCatch> getFishSpeciesTotalCatchList() {
        return fishSpeciesTotalCatchList;
    }

    public void setFishSpeciesTotalCatchList(ArrayList<FishSpeciesTotalCatch> fishSpeciesTotalCatchList) {
        this.fishSpeciesTotalCatchList = fishSpeciesTotalCatchList;
    }

    public ArrayList<MammalAndBirdsTotalCatch> getMammalAndBirdsTotalCatchList() {
        return mammalAndBirdsTotalCatchList;
    }

    public void setMammalAndBirdsTotalCatchList(ArrayList<MammalAndBirdsTotalCatch> mammalAndBirdsTotalCatchList) {
        this.mammalAndBirdsTotalCatchList = mammalAndBirdsTotalCatchList;
    }

}
