import {useState, useEffect} from 'react';
import { ethers } from 'ethers';
import contractABI from "../contracts/Walendly.json";
import contractAddress from "../contracts/contract-address.json";

import { ViewState, EditingState, IntegratedEditing } from '@devexpress/dx-react-scheduler';
import { Scheduler, WeekView, Appointments, AppointmentForm } from '@devexpress/dx-react-scheduler-material-ui';

import Slider, { Range } from 'rc-slider';
import 'rc-slider/assets/index.css';

import {Box, Button} from 'grommet';
//import SettingsSuggestIcon from '@mui/icons-material/SettingsSuggest';

const schedulerData = [
    {startDate: `2022-07-25T10:45`, endDate: `2022-07-25T11:45`, title: 'Meeting 1'},
    {startDate: `2022-07-26T11:45`, endDate: `2022-07-26T12:45`, title: 'Meeting 2'},
];


const provider = new ethers.providers.Web3Provider(window.ethereum);
const contract = new ethers.Contract(contractAddress.Walendly, contractABI.abi, provider.getSigner());

console.log(contract);

const Calendar = (props) => {

    //State for admin and rate
    const[isAdmin, setIsAdmin] = useState("");
    const[showAdmin, setShowAdmin] = useState("");
    const[rate, setRate] = useState("");
    const[appointments, setAppointments] = useState([]);

    const getData = async () => {
        const owner = await contract.owner();
        console.log(owner.toUpperCase());

        console.log("The current connected address is:", props.account.toUpperCase());
        setIsAdmin(owner.toUpperCase() === props.account.toUpperCase());

        const rate = await contract.getRate();
        console.log(rate.toString());
        setRate(ethers.utils.formatEther(rate.toString()));

        const appointmentData = await contract.getAppointments();
        console.log('Appointments: ', appointmentData);

        transformAppointmentData(appointmentData);

    }

    const transformAppointmentData = (appointmentData) => {
        let data = [];
        appointmentData.forEach(appointment => {
            data.push({
                title: appointment.title,
                startDate: new Date(appointment.startTime * 1000),
                endDate: new Date(appointment.endTime * 1000)
            });
        });

        setAppointments(data);
    }

    useEffect(() => {
        getData();
    }, []);

    const saveAppointment = async (data) => {
        console.log("Appointment Saved");
        console.log(data);

        const appointment = data.added;
        const title = appointment.title;
        const startTime = appointment.startDate.getTime() / 1000;
        const endTime = appointment.endDate.getTime() / 1000;

        try {
            const cost = ((endTime - startTime) / 60) * (rate * 100)/100;
            const msg = {value: ethers.utils.parseEther(cost.toString())};
            let tx = await contract.createAppointment(title, startTime, endTime, msg);

            await tx.wait();
        } catch (error) {
            console.log(error);
        }
    }

    const saveRate = async () => {
        console.log('Saving rate of', ethers.utils.parseEther(rate.toString()));
        const tx = await contract.setRate(ethers.utils.parseEther(rate.toString()));
    };

    const handleSliderChange = (newValue) => {
        console.log('Slider changed to', newValue);
        setRate(newValue);
    }
    
    const Admin = () => {
        return <div id="admin">
                <h3>Set Minutely Rate</h3>
                <Slider
                startPoint={0}
                defaultValue={parseFloat(rate)}
                min={0}
                max={0.01}
                marks={{ 0.001: 0.001, 0.005: 0.005, 0.01: 0.01 }}
                step={0.001}
                onChange={handleSliderChange}
                />
                <br /><br />
                <Button onClick={saveRate}>Save Configuration</Button>
        </div>
    }

    return (<div>
        <div>
        { isAdmin && <Admin />}
        </div>
        <div id="calendar">
            <Scheduler data={appointments}>
                <ViewState />
                <EditingState onCommitChanges={saveAppointment}/>
                <IntegratedEditing />
                <WeekView startDayHour={9} endDayHour={19}/>
                <Appointments />
                <AppointmentForm />
            </Scheduler>
        </div>
    </div>);
}

export default Calendar;