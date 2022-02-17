Func ChartsPageFind($file)
	;Page 1
	$value = StringInStr($file, "Consent for services")
	If Not $value = 0 Then
		Global $page = "Page 1"
	Else
		$value = StringInStr($file, "Caregiver Family Status")
		If Not $value = 0 Then
			Global $page = "Page 1"
		Else
			$value = StringInStr($file, "Hands Referral")

			If Not $value = 0 Then
				Global $page = "Page 1"
			Else
				$value = StringInStr($file, "Referral Record Screen")

				If Not $value = 0 Then
					Global $page = "Page 1"
				Else
					$value = StringInStr($file, "Participant's Contact Information")

					If Not $value = 0 Then
						Global $page = "Page 1"
					Else
						$value = StringInStr($file, "Notice of Privacy Practices")

						If Not $value = 0 Then
							Global $page = "Page 1"
						Else
							$value = StringInStr($file, "Family Rights")

							If Not $value = 0 Then
								Global $page = "Page 1"
							Else
								$value = StringInStr($file, "Partnership Agreement")

								If Not $value = 0 Then
									Global $page = "Page 1"
								Else
									$value = StringInStr($file, "Child Family Status")

									If Not $value = 0 Then
										Global $page = "Page 1"
									Else
										$value = StringInStr($file, "first steps referral")

										If Not $value = 0 Then
											Global $page = "Page 1"
										Else
											$value = StringInStr($file, "cribs for kids referral")

											If Not $value = 0 Then
												Global $page = "Page 1"
											Else
												$value = StringInStr($file, "poison")

												If Not $value = 0 Then
													Global $page = "Page 1"
												Else
													$value = StringInStr($file, "carbon monoxide")

													If Not $value = 0 Then
														Global $page = "Page 1"
													Else
														$value = StringInStr($file, "Photographed-Videotaped")

														If Not $value = 0 Then
															Global $page = "Page 1"
														Else
															;Page 2
															$value = StringInStr($file, "parent survey summary")

															If Not $value = 0 Then
																Global $page = "Page 2"
															Else
																$value = StringInStr($file, "parent survey score sheet")

																If Not $value = 0 Then
																	Global $page = "Page 2"
																Else
																	$value = StringInStr($file, "goal sheet")

																	If Not $value = 0 Then
																		Global $page = "Page 2"
																	Else
																		;Page 3
																		$value = StringInStr($file, "childproofing checklist")

																		If Not $value = 0 Then
																			Global $page = "Page 3"
																		Else
																			$value = StringInStr($file, "home inventory")

																			If Not $value = 0 Then
																				Global $page = "Page 3"
																			Else
																				$value = StringInStr($file, "parent completion levels")

																				If Not $value = 0 Then
																					Global $page = "Page 3"
																				Else
																					;page 4
																					$value = StringInStr($file, "contact")

																					If Not $value = 0 Then
																						Global $page = "Page 4"
																					Else
																						;page 5
																						$value = StringInStr($file, "Home Visit Log")

																						If Not $value = 0 Then
																							Global $page = "Page 5"
																						Else
																							$value = StringInStr($file, "RN SW log")

																							If Not $value = 0 Then
																								Global $page = "Page 5"
																							Else
																								$value = StringInStr($file, "domestic violence screen")

																								If Not $value = 0 Then
																									Global $page = "Page 5"
																								Else
																									$value = StringInStr($file, "edinburgh scale")

																									If Not $value = 0 Then
																										Global $page = "Page 5"
																									Else
																										$value = StringInStr($file, "exit")
																										If Not $value = 0 Then
																											Global $page = "Page 5"
																										Else
																											$value = StringInStr($file, "ASQ3")
																											If Not $value = 0 Then
																												Global $page = "Page 5"
																											Else
																												$value = StringInStr($file, "Service Record")
																												If Not $value = 0 Then
																													Global $page = "Page 5"
																												Else
																													$value = StringInStr($file, "ASQ SE")
																													If Not $value = 0 Then
																														Global $page = "Page 5"
																													Else
																														$value = StringInStr($file, "Support and resource plan")
																														If Not $value = 0 Then
																															Global $page = "Page 5"
																														Else
																															$value = StringInStr($file, "Health Screen")
																															If Not $value = 0 Then
																																Global $page = "Page 5"
																															Else
																																Global $page = "Page 0"
																															EndIf
																														EndIf
																													EndIf
																												EndIf
																											EndIf
																										EndIf
																									EndIf
																								EndIf
																							EndIf
																						EndIf
																					EndIf
																				EndIf
																			EndIf
																		EndIf
																	EndIf
																EndIf
															EndIf
														EndIf
													EndIf
												EndIf

											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

	EndIf
EndFunc   ;==>ChartsPageFind


