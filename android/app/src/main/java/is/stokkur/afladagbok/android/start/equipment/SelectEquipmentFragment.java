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

package is.stokkur.afladagbok.android.start.equipment;

import androidx.lifecycle.ViewModelProviders;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.start.StartTourActivity;
import is.stokkur.afladagbok.android.start.StartTourViewModel;

/**
 * Created by annalaufey on 11/29/17.
 */

public class SelectEquipmentFragment
        extends BaseFragment
        implements EquipmentAdapter.FishingEquipmentTypeListener {

    @BindView(R.id.equipment_recycler_view)
    RecyclerView recyclerView;
    StartTourViewModel viewModel;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.select_equipment_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(getActivity()).get(StartTourViewModel.class);
        viewModel.initStartTourEquipment();

        initRecyclerView(viewModel.getFishingEquipmentTypes());
        ((StartTourActivity) getActivity()).changeHeaderTitle(getString(R.string.choose_equipment));
        ((StartTourActivity) getActivity()).setKeyboardDown();
        return view;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    private void initRecyclerView(ArrayList<FishingEquipments> equipmentTypes) {
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setAdapter(new EquipmentAdapter(equipmentTypes, getActivity(), this,
                viewModel.preferredEquipmentId()));
    }

    @Override
    public void onTypeSelected(FishingEquipments equipment) {
        BaseActivity activity = (BaseActivity) getActivity();
        String type = equipment.getType();
        viewModel.getStartTourEquipment().setFishingEquipmentTypeId(equipment.getId());
        if (type.compareTo(FishingEquipments.HAND) == 0) {
            activity.replaceFragmentWithAnimation(new FishingHandFragment());
        } else if (type.compareTo(FishingEquipments.LINE) == 0) {
            activity.replaceFragmentWithAnimation(new FishingLineFragment());
        } else if (type.compareTo(FishingEquipments.NET) == 0) {
            activity.replaceFragmentWithAnimation(new FishingNetFragment());
        }
    }

}
