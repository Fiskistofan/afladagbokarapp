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

package is.stokkur.afladagbok.android.login;

import androidx.annotation.StringRes;

import java.util.ArrayList;
import java.util.List;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.models.Ship;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;

public final class LoginUtils {

    static public @StringRes
    int validLogin(ProfileResponse response) {
        if (response == null || response.getProfile() == null) {
            return R.string.login_general_error;
        }
        if (nullOrEmptyList(response.getPorts())) {
            return R.string.login_no_ports;
        }
        if (nullOrEmptyList(response.getEquipment())) {
            return R.string.login_no_default_equipment;
        }
        if (nullOrEmptyList(response.getFishSpecies())) {
            return R.string.login_no_fish_species;
        }
        if (nullOrEmptyList(response.getOtherSpecies())) {
            return R.string.login_no_other_species;
        }
        if (nullOrEmptyList(response.getFishingEquipments())) {
            return R.string.login_no_fishing_equipment;
        }
        ArrayList<Ship> ships = response.getShips();
        if (nullOrEmptyList(ships)) {
            return R.string.login_no_ships;
        }

        String json = GsonInstance.sInstance.toJson(response);
        Persistence.saveStringValue(Persistence.KEY_PROFILE, json);

        String currentBoatId = Persistence.getStringValue(Persistence.KEY_CURRENT_BOAT_ID);
        if (currentBoatId != null) {
            int i = 0;
            Ship ship;
            int size = ships.size();
            for (; i < size; ++i) {
                ship = ships.get(i);
                if (String.valueOf(ship.getId()).compareTo(currentBoatId) == 0) {
                    break;
                }
            }
            if (i >= size) {
                currentBoatId = null;
            }
        }
        if (currentBoatId == null) {
            currentBoatId = String.valueOf(response.getShips().get(0).getId());
        }
        Persistence.saveStringValue(Persistence.KEY_CURRENT_BOAT_ID, currentBoatId);

        return 0;
    }

    static private boolean nullOrEmptyList(List<?> list) {
        return list == null || list.isEmpty();
    }

    private LoginUtils() {

    }

}
