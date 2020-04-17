import React from 'react';
import { Provider } from 'react-redux';
import { HeaderProfile, Bootstrap, store } from '@steedos/react';

function HeaderProfileContainer(prop){
	return (
		<Provider store={store}>
			<Bootstrap>
				<HeaderProfile avatarURL={prop.avatarURL} logoutAccountClick={prop.logoutAccountClick} settingsAccountClick={prop.settingsAccountClick}/>
			</Bootstrap>
		</Provider>
	)
}

export default HeaderProfileContainer;