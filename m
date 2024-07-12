Return-Path: <linux-xfs+bounces-10589-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DB692F280
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2024 01:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4684F1C22938
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2024 23:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7298019FA61;
	Thu, 11 Jul 2024 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALTH7nLL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DH68gGGQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB3D1DFE3
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720739484; cv=fail; b=c445pMxSDGDpsWhwnv4NNG2Q2LlCe+51PdoP++eFag7F2gheAP1UB8CaWB0yAdD8CwTa0WvMtcJhO8awbMC83/xabJoYoLjS9b/Fkl6FFcxQBXuyG+ejeuVqSqW5dbv+693tTHwQd7sdgLjWlyLjO218Q+RToihZaC6FW8UNCbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720739484; c=relaxed/simple;
	bh=gbX9xiL4tanm9WALVNTskBqDayjSC4OTyWiWdMebToA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ggqaNYt2mEpXF4kioJ9A3/fhL6Ue2YoD709Ri4qyTxmTSMzR8ium2vE1ZU5hlThvRQcRR7MTBHeuE/IPQP9oZp9jyKIkYFwxHGuVvCpcx1kYt6jhgQmZ3NM9JRwKE71bU9IUlHsq5HsFW4shVCdNX5e8K0de8LvIpCmly7VN9wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ALTH7nLL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DH68gGGQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXVKm031685;
	Thu, 11 Jul 2024 23:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=gbX9xiL4tanm9WALVNTskBqDayjSC4OTyWiWdMebT
	oA=; b=ALTH7nLL8SPFJKaJgcTdoseLvazN0LtKMf3dLMkHkCf+AsX1fytG1cT6T
	/g+WilxE2/TIYDYeZEZVNZwT/3AbOGF7GoiTQ7IrW8V95ho7ZxzPhyK5EoQg+a8z
	HF7aeAXiofOO/TKw93JQv/KxLclgeLZuDdzucr3Mh9QRrl2tIzUHr5GSeqF/Y1mQ
	OTu7BsN2/ClswM0ET/s+cjaRN3DjOXmtzp8iJJIufI2A3rEaFsww33AE67dpUaXv
	9ZY336Jggi902MiGJFq0k6uN7PQRLfziCBYeUpdHxH27MlKyRWdJdKZrTS8SDsbB
	2wjkRtrP2ZDv403LOvAnfZRAjNxBQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybtsmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:11:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BLAdFK029913;
	Thu, 11 Jul 2024 23:11:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvbwjd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:11:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j+LGtkFcbFGa/ff3v+83A20a2MSIfWnRNSL3ipsBAAkPhQmqhg+NpuP9WGex2LmbXgTURx6pots9NU7277Khq54lHdKkjw/bFMB5SKhC6LpUvyf+lUJzf83mZfaEVogCceYcAiuC1/8agWKdwvejN7blt0M1l/3Y1k0HvColBNbD88Z0PbExSZyhbGaefw/iWBRt6JHDevzN/KSn5cNj76g2rwqruG/uBSkax+4DPhkW35fifo1NDIz1uMrkZOLYjXQXOUBw6SLtB/HaB47yWEM9en/SnkWF+IgGr6U0JRc5zXnqNbUx9VJbSBzrDaPC1fNsMLkgHyhfCuzc3oI18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbX9xiL4tanm9WALVNTskBqDayjSC4OTyWiWdMebToA=;
 b=t2R0wzggTk3nBpIcd0geB/4POLLHzapRetuKdfn3yQX4YSuYSdAUDMCOPA2xXUgPb/YyEw4mHnm1VbkxRNsXkaqs11dm5mfuk2OgUngr2ad0G8ys120aslK7lsyHceXJbp4AgaysrCJxFGi1RB/REbL9MeypBdMNvh/9ClD1lqG1Gmztxot20g23SmkDCzYtH9ljUQYun+ETtBht+zasf81DctIddyO2ppawyREJ3HPdAV63L/7CIny8l40JDKkU9hBpZgQqbzbuxwvdHcmY20kJrMz/PppOZG6duA4l9tNLf6gYbygWeNeWVBJ6VbCOjkVal2DTRLYTZ0NFHZ+itg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbX9xiL4tanm9WALVNTskBqDayjSC4OTyWiWdMebToA=;
 b=DH68gGGQTq8E/2m2DGCAj2wa1TOq6mnsLcw9FwTtyJQhe4iJRSqUEsm8YPzqKLtby9JrweGvD9/k6CFqbg0tdoDaVI+OBzxe5dqg/vOGJtPytmEbeRKIADYj7W6AP8WhV0Xx3oiVpMlJQdZ5YJ77iK8DIDS/ih/t1gcuuFRZJUY=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 23:11:14 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:11:14 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Thread-Topic: [PATCH 6/9] spaceman/defrag: workaround kernel
 xfs_reflink_try_clear_inode_flag()
Thread-Index: AQHa0jOvpBMHbEeYYUi6eQA2kII/eLHu3xqAgANLswA=
Date: Thu, 11 Jul 2024 23:11:14 +0000
Message-ID: <B64BC867-CA7C-4F57-9D0C-97B2B09952D6@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-7-wen.gang.wang@oracle.com>
 <20240709205121.GV612460@frogsfrogsfrogs>
In-Reply-To: <20240709205121.GV612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SN7PR10MB7074:EE_
x-ms-office365-filtering-correlation-id: 700a6f5f-6c8e-417d-4f6f-08dca1fec31a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?M0lxdnJEbDZpMjRTbFRjNEZBbElJd0hDTE10NXk1WlFqWkN5WXIvMHZaVmdR?=
 =?utf-8?B?dlpmQ0hWWlNDbklVdEcwUGJnRXFtWGQwN3RSdHBNNnRrYjlMMndBTGRPY2Zl?=
 =?utf-8?B?WkdwalZPMUR2MmFtQXJnLzR4aVdhUDZWZXdTbGdqajE4L1loN21mMEJzdVFV?=
 =?utf-8?B?S3RYSExWdUQ0eEdLQnNtaytjaVFkT3RVOFlzM2tpelNQQ2VtZEV0S1dMSlVk?=
 =?utf-8?B?a0hFUVlKeW0rY3g2ZTMzZWc0UUN6aWpQSFJSaGdYK0FQZy9waU1YaEJOSXJ0?=
 =?utf-8?B?dG9QWFplNFlEcmxTeWI4SlNEcGZlQm1ETzFaYmVBSVVzR1lpQVA3UEhrZHRX?=
 =?utf-8?B?Kzl1bUFyTGZwbDRNclpaNXVYWi9XNThTOU03RXZ6V1YzN2hNR2hwckVkcjJm?=
 =?utf-8?B?VC9FeTlXdjI2Smp6aEYwRXFTclN4RFRadjd3Q2M1ZS9XYUJ1cUxuNm9mNkhJ?=
 =?utf-8?B?MXFKNkNVVGdJVjJpcG5TeVVoWWxWdDQwMXZxOU9iMlJQc092VnVpYkwyZ3d6?=
 =?utf-8?B?RDZQanMzQ0tHVnk2MDFjYkhndWNUNVVwVTN0SmcxRzNYdStqdzVJUzFwUlpM?=
 =?utf-8?B?Y0Vrc2RiSjhkcmdLK0VvNTBpVjMvMFQ2SGkvS1pjaEJJOERGdWMvNm9pOUw3?=
 =?utf-8?B?UlFyTXhTVEFwZklGem9uZlpDTmVCVWpOaXlhZkozMmdYQitEanUrTFdYdUY5?=
 =?utf-8?B?bDlNWGY0VDVNZnRhSytra0JCTXVoM2d0cEZ0RWN1aC9laDFlQnZYNGVkcFIw?=
 =?utf-8?B?NDhnRTlncEMyVVM5NnhSMVZ2ZWRtdysxbURqWGpyaHl2dTdZbGJTRy9CQXVB?=
 =?utf-8?B?T0dxdktvNUtZaVltOEZJaG40ZExReTlDWmUybEpMdklHeHhnRWZMWmJudTlG?=
 =?utf-8?B?d2RwaGY5bHlDS3V1bVVVNUxkMVhMTk40UFI5cU93VzQyQStkbTFDUlFCR2Iv?=
 =?utf-8?B?RXNlNmQxZlJWNklCdmlia2tuOS9MTjk2MnhvR09idFBCSmFoSXUzSnQ2Znhh?=
 =?utf-8?B?dHFWYkJ3Q1czQjRTSWZIWGtidmRQUGtZcFNGeTBqS05DcWhWazhlS3pjY0RZ?=
 =?utf-8?B?UEZvckplZG4zL2l4S0s1VExwKytMOEx5R2RuN1JDTTFLdzE1emlHNzRHZnpw?=
 =?utf-8?B?NGJUV2ZvSk1HTVZqL2NDWWNieFg0TUhZN1pEbUQ1djB5Vk1NUTdFdGpIcVRs?=
 =?utf-8?B?VGwwNC9oaGkwbmpDb1hIbHVtMFJ5dEcvYUE5b2t5NnRNMXduYldrVUk0VEtU?=
 =?utf-8?B?OFRZdjNSbi93SHpmRVVzQUFidU1rWTFCc2RaMXRqeVRBTVFJTVFMQlhySzQ2?=
 =?utf-8?B?ZjQ4Rnl6L2JueExvSC9pU2NwWEFMK2oweHJjc0cyeGZoWVBNRXpyWm0waGxU?=
 =?utf-8?B?K2FnR1B1L0hSNnpTaGZrU1dSblI1MVVUeWlqTitUcGZ2VTJpVGIrUWcvQVNu?=
 =?utf-8?B?NG9CNytEOUNaMmYxZkNGUE01eThQUjl0ZVhhWjdlQnA3QzZjcU0xTmV1Qi9L?=
 =?utf-8?B?RjBVOFdrK1BFNERyNmd3VE04YmQyRDJHVHR4RzY4K0xPbkVRUjg5bi8zSnp2?=
 =?utf-8?B?WXIvVHpON0I3OWxDYkRRWTEzMGdNS0VPbGkzSldjZ0tnWm5RMVpuVE9WUStn?=
 =?utf-8?B?M28yV3hqbytFV0UvRW14bzd5bXpSbExCMFJMYWFTOTUwR1UwVUJlYUJQUG5I?=
 =?utf-8?B?d0pwOFMwSTBLMWNDM1p3OVFDaWhVOWhHenV6eXl4bHZGMDRQY1hGajBGaXFX?=
 =?utf-8?B?dC9LeHRCOVh3OERvVml3SGJ0bk5OaEZjNDRRV29ISXdsRTZxRHhGbS9Fd1h6?=
 =?utf-8?B?MHJtVGY3N2lWa3c4M1pZdVlCdEU4NWJBZFM0TTVsVWVDMVY2UlFYbW0xemlM?=
 =?utf-8?B?RkRtMUIvNGVvbnhCcTNldUVyc1Z3djI1NFpvWllPdk5WdEE9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TTdxTHZxUmFBZElCT2MwVXNrZFBDdzF6V1U3TDVYYlJaQUZxNnhWb1hOWVYv?=
 =?utf-8?B?ZlpRV0lRVnNTZGpyWXhrQ0drYk1UN1VhWElvNzl2b3FybHFGd3kzYk9ucUc0?=
 =?utf-8?B?R0FTbVdGZ2pYVHcxSzNadXJxQmh3Nk9nY1pBVzFlQ0c2RmNNNVBiZXBRSi80?=
 =?utf-8?B?WnF2Y1RTRVMwYndRM0swN0cwazFZZ0tvWGU3SDgwN0ZORnJQOXE2Nitza1JZ?=
 =?utf-8?B?eXVTMlZGb3pSdzF6azJjWWZ3TjlENWs5NGdhNy83VzNPQWNRVTFGSStWM21w?=
 =?utf-8?B?Z05BZnNpM3dPeXZIem5WSzZuMVFPWFhPOWhlZGRJZk9yTmFKZ2U3SGE5cUFN?=
 =?utf-8?B?ZkhwTFRZSk5kbUswS25PMkVLaG1vbzQzVHE2a1IvNS8rSXo2c3Z6cjU5RWpx?=
 =?utf-8?B?Y2hYK3ZlSk8xQXpUM2hQYkhVS1FSZkdrQ2FtWGQwV1pwOVlVRThxTDQ1NlFW?=
 =?utf-8?B?MEllR0JVQkJrelBPOEloSFFVR0RPUWJoWUpnblErTlcyVG1HQlpWK3NRZVNE?=
 =?utf-8?B?U1JHTXBtVjZOM214NG1MeVZ6Qzg0YUdYcGFUeW9LQWFPdEl3S3JuOVFPN0Y4?=
 =?utf-8?B?VzlNdUs3dGd6WXhlZklzd094c0FPZnZWZGpDSEVacVZ0bEJ1cHRwQ3NpS1VI?=
 =?utf-8?B?WWU2M1BEU2FBbnprUWFwTHVPeFl4WVQyeG83WUFUVUlpR0ptZ3NwMGdRNENi?=
 =?utf-8?B?RmVUY2hsTkJScFFpWnpHMHNhbjU4Q2MwT0V2NEFvWW9Ya0M3b1lFQldvaFU3?=
 =?utf-8?B?ZEszSTg4R0tCelJ4Rlo2WW5sSkc3QW5vVnM5dTRlYW1tSFkydkQrNUtXWlZ6?=
 =?utf-8?B?eUxIMlp5b2tnUE4yKy9nODV2djJlWjFoMlVqYVNXUGF0RllDZlhXb1lTeHBq?=
 =?utf-8?B?QmhvNDhjOC9xbnJFdFA1a2gvcDcrMmZ5RVE5RGlqNWhHRTFIZVlqeEgzd0ls?=
 =?utf-8?B?TVFVSXh5YVJWV3ROV3VsSnhBMjhaWkU0NFJBNktRRCtPZ0tnbDZZelgwckk3?=
 =?utf-8?B?aFlpaS9VZXdUQit4NHQxNzF2TDZzR2xneEx3dnBJRWtpc2VzZmlISSt0NFNr?=
 =?utf-8?B?MHZselllLzA4VXprckpLRjhraE04NmllNG13WGtKSGNBRDdKZ3c2Q2EvOHpv?=
 =?utf-8?B?MmQ4SG5zVWlnOUVQR0JaUXQwZG4zUUlLMDRrVUxRV2FVdWZVMUxIbEY1bitI?=
 =?utf-8?B?anZ1K0FUWlYybXNyVzl2ZE5mM3Ywck1DNFlqbUFueWxaRUFaNFhwbVdML0Rp?=
 =?utf-8?B?WWV1MENuaFVmaWY4WW9tK2lGd1prd3R3T3hLOTlMa1JaNlR5NDRSVjNTdGhs?=
 =?utf-8?B?NnBYRkJMQjQ1YkZiWTRmdWpvMWxmdHhtQlR0UFpYeUovTURHTHp0a28reFhk?=
 =?utf-8?B?MjlGSHdaaUJNRkJZSzVLOTdKTFBSU1UxcE02TEhlKzdCV285cFlITE5HTERu?=
 =?utf-8?B?Qk13anF6cFdpRnFvUjVnL0FvdysvcSsweTBiazR1Q21SSUQwL1dQcG5EQUV2?=
 =?utf-8?B?c1Bic1l5WGQ1d0ZpY2xkc05XRXByZUVWYlFrNkU2YTRGMkNwUmJXeEJEdHVR?=
 =?utf-8?B?Tjh5WjduK1hZN0JKdG56NUVyL0lsZlVYNTdKc3ROSUNEWHJrVXFWcTltNGdQ?=
 =?utf-8?B?aGh4aXZIbEkzMHhPRnpwc2J3b3ZJb2JEemQ3QnBHYnNiWE00SlI4UENwenNC?=
 =?utf-8?B?QjJWRjBhbjk1Y3R2UmkvVlFWS09MdjNxNSt6YkIyK1cyYWpDSEZ3bVZxQ21E?=
 =?utf-8?B?ejFOZGV2U2NuaGVKM3RWYStrS0MvV3c1OUlLQ1NnN0VnV2k5cnVKY1d1eVpX?=
 =?utf-8?B?WFoyNnZJcmpFRVpyRnFGMnFTNUxnRlBEU2x1M2J1b1cycGpuRk84Y0N4d2lR?=
 =?utf-8?B?MFBzRU8zOFVveXlBcTZvdDgzRW9ubW9DZzhWSGFSYzhoMVVRSTFjTHFGUTJ4?=
 =?utf-8?B?ZUd0SWJzakVUMFp0a0lhSnhQMlpEdDZKQ0RqVElqaTNTOXc5b3NodDlEQno5?=
 =?utf-8?B?WHRsbEN5Z3FCNGwyQ1BKWkVoK1FaVGlaeTJhMURManVoRkR3QWc2N2l5MVQ1?=
 =?utf-8?B?QlBhMnhaKzl4TU1ZL09oai9FdUZITGFFcWcyeTlaTGdZRUpQV0FkR2hGanlu?=
 =?utf-8?B?SlVabXlMVUNxc2ovTlBSYkpHK1pITmdkM29pRGNjQ2NyQXFUbWpMSDdIbEhB?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06DAE5CAC80C9144866A99FD2355E924@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GT7kXQ3L68TPY/SyF1Op5jnYIfqsmMRi+2LVksIHQ/ppinY2Ny9EoQj35skoW4oDGNLWsf7U22Y2zp7mHGa/MUbmHacguCyy3cd9yUGu+e75Y/NhD3izRKyCbqcbO7neN7r/NUA0g3YhlA4fLT682yBw5MIAAu8psgsomchj/ODbXErfPLYru8yk09moeZoVhWDBv4rYDXTiu3i0wgenuq7HmXaqKxJZebWUtX1m17fEE6Mbli7/M6rTOsaHH93X5uJLY91XwECkTwecMq1LCdzcy53Cv9IRY8R8xPwqfN32FA7vdBUdQRyLz+XWbd8nM2EEO7NR17Sl9o9tFh0ZOwOuNhQugk4cRq5JwfkRUyeP6o55qytrPmUHu5rsSQD9eCUHDs9/26lajrvakoHLBwBw4jQXpdjSHurHsztxdTOY5w+vD/8GCz/wJ0oXS8NKwkWSKX7rCA4zq8jpepcyAzPuUS1Yc/+4rWCJi8NMvm78UlOTNoiQAH+14quUoUyY1n2WQmHtsAXvX+z0UY+wtOJK3bZU8r9WMUFwNQKHFdTe7775Wv058SAix2CzUwZSJcPZ9r0nmzwf2k+2OAM707lZdDdXUEiVhw1wPbov+lA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700a6f5f-6c8e-417d-4f6f-08dca1fec31a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:11:14.6601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbY1txFMoHs8tJI/Z2S9HALH6N7q2Wt29Q/nqLGnvLReF5tBY8T+J4T0Bn0lC5J2WErlEEsGqJ+F3OuuqdE/1rS0M/0RMQ9ccOU/A9L4lHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110164
X-Proofpoint-GUID: 3DudSrYcouhbSIwbPlzYiwi5xWDJHMPp
X-Proofpoint-ORIG-GUID: 3DudSrYcouhbSIwbPlzYiwi5xWDJHMPp

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDE6NTHigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyNVBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiB4ZnNfcmVmbGlua190cnlfY2xl
YXJfaW5vZGVfZmxhZygpIHRha2VzIHZlcnkgbG9uZyBpbiBjYXNlIGZpbGUgaGFzIGh1Z2UgbnVt
YmVyDQo+PiBvZiBleHRlbnRzIGFuZCBub25lIG9mIHRoZSBleHRlbnRzIGFyZSBzaGFyZWQuDQo+
PiANCj4+IHdvcmthcm91bmQ6DQo+PiBzaGFyZSB0aGUgZmlyc3QgcmVhbCBleHRlbnQgc28gdGhh
dCB4ZnNfcmVmbGlua190cnlfY2xlYXJfaW5vZGVfZmxhZygpIHJldHVybnMNCj4+IHF1aWNrbHkg
dG8gc2F2ZSBjcHUgdGltZXMgYW5kIHNwZWVkIHVwIGRlZnJhZyBzaWduaWZpY2FudGx5Lg0KPiAN
Cj4gSSB3b25kZXIgaWYgYSBiZXR0ZXIgc29sdXRpb24gd291bGQgYmUgdG8gY2hhbmdlIHhmc19y
ZWZsaW5rX3Vuc2hhcmUNCj4gb25seSB0byB0cnkgdG8gY2xlYXIgdGhlIHJlZmxpbmsgaWZsYWcg
aWYgb2Zmc2V0L2xlbiBjb3ZlciB0aGUgZW50aXJlDQo+IGZpbGU/ICBJdCdzIGEgcGl0eSB3ZSBj
YW4ndCBzZXQgdGltZSBidWRnZXRzIG9uIGZhbGxvY2F0ZSByZXF1ZXN0cy4NCg0KWWVwLg0KQW55
d2F5IHRoZSBjaGFuZ2UsIGlmIHRoZXJlIHdpbGwgYmUsIHdvdWxkIGJlIGluIGtlcm5lbC4NCldl
IGNhbiB1c2UgLW4gb3B0aW9uIHRvIGRpc2FibGUgdGhpcyB3b3JrYXJvdW5kIGluIGRlZnJhZy4N
Cg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo+IA0KPiAtLUQNCj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBX
ZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4NCj4+IC0tLQ0KPj4gc3BhY2Vt
YW4vZGVmcmFnLmMgfCAxNzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDE3MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvc3BhY2VtYW4vZGVmcmFnLmMgYi9zcGFjZW1hbi9k
ZWZyYWcuYw0KPj4gaW5kZXggZjhlNjcxM2MuLmI1YzViMTg3IDEwMDY0NA0KPj4gLS0tIGEvc3Bh
Y2VtYW4vZGVmcmFnLmMNCj4+ICsrKyBiL3NwYWNlbWFuL2RlZnJhZy5jDQo+PiBAQCAtMzI3LDYg
KzMyNywxNTUgQEAgZGVmcmFnX2ZzX2xpbWl0X2hpdChpbnQgZmQpDQo+PiByZXR1cm4gc3RhdGZz
X3MuZl9ic2l6ZSAqIHN0YXRmc19zLmZfYmF2YWlsIDwgZ19saW1pdF9mcmVlX2J5dGVzOw0KPj4g
fQ0KPj4gDQo+PiArc3RhdGljIGJvb2wgZ19lbmFibGVfZmlyc3RfZXh0X3NoYXJlID0gdHJ1ZTsN
Cj4+ICsNCj4+ICtzdGF0aWMgaW50DQo+PiArZGVmcmFnX2dldF9maXJzdF9yZWFsX2V4dChpbnQg
ZmQsIHN0cnVjdCBnZXRibWFweCAqbWFweCkNCj4+ICt7DQo+PiArIGludCBlcnI7DQo+PiArDQo+
PiArIHdoaWxlICgxKSB7DQo+PiArIGVyciA9IGRlZnJhZ19nZXRfbmV4dF9leHRlbnQoZmQsIG1h
cHgpOw0KPj4gKyBpZiAoZXJyKQ0KPj4gKyBicmVhazsNCj4+ICsNCj4+ICsgZGVmcmFnX21vdmVf
bmV4dF9leHRlbnQoKTsNCj4+ICsgaWYgKCEobWFweC0+Ym12X29mbGFncyAmIEJNVl9PRl9QUkVB
TExPQykpDQo+PiArIGJyZWFrOw0KPj4gKyB9DQo+PiArIHJldHVybiBlcnI7DQo+PiArfQ0KPj4g
Kw0KPj4gK3N0YXRpYyBfX3U2NCBnX3NoYXJlX29mZnNldCA9IC0xVUxMOw0KPj4gK3N0YXRpYyBf
X3U2NCBnX3NoYXJlX2xlbiA9IDBVTEw7DQo+PiArI2RlZmluZSBTSEFSRV9NQVhfU0laRSAzMjc2
OCAgLyogMzJLaUIgKi8NCj4+ICsNCj4+ICsvKiBzaGFyZSB0aGUgZmlyc3QgcmVhbCBleHRlbnQg
d2l0aCBzY3JhY2ggKi8NCj4+ICtzdGF0aWMgdm9pZA0KPj4gK2RlZnJhZ19zaGFyZV9maXJzdF9l
eHRlbnQoaW50IGRlZnJhZ19mZCwgaW50IHNjcmF0Y2hfZmQpDQo+PiArew0KPj4gKyNkZWZpbmUg
T0ZGU0VUXzFQQiAweDQwMDAwMDAwMDAwMDBMTA0KPj4gKyBzdHJ1Y3QgZmlsZV9jbG9uZV9yYW5n
ZSBjbG9uZTsNCj4+ICsgc3RydWN0IGdldGJtYXB4IG1hcHg7DQo+PiArIGludCBlcnI7DQo+PiAr
DQo+PiArIGlmIChnX2VuYWJsZV9maXJzdF9leHRfc2hhcmUgPT0gZmFsc2UpDQo+PiArIHJldHVy
bjsNCj4+ICsNCj4+ICsgZXJyID0gZGVmcmFnX2dldF9maXJzdF9yZWFsX2V4dChkZWZyYWdfZmQs
ICZtYXB4KTsNCj4+ICsgaWYgKGVycikNCj4+ICsgcmV0dXJuOw0KPj4gKw0KPj4gKyBjbG9uZS5z
cmNfZmQgPSBkZWZyYWdfZmQ7DQo+PiArIGNsb25lLnNyY19vZmZzZXQgPSBtYXB4LmJtdl9vZmZz
ZXQgKiA1MTI7DQo+PiArIGNsb25lLnNyY19sZW5ndGggPSBtYXB4LmJtdl9sZW5ndGggKiA1MTI7
DQo+PiArIC8qIHNoYXJlcyBhdCBtb3N0IFNIQVJFX01BWF9TSVpFIGxlbmd0aCAqLw0KPj4gKyBp
ZiAoY2xvbmUuc3JjX2xlbmd0aCA+IFNIQVJFX01BWF9TSVpFKQ0KPj4gKyBjbG9uZS5zcmNfbGVu
Z3RoID0gU0hBUkVfTUFYX1NJWkU7DQo+PiArIGNsb25lLmRlc3Rfb2Zmc2V0ID0gT0ZGU0VUXzFQ
QiArIGNsb25lLnNyY19vZmZzZXQ7DQo+PiArIC8qIGlmIHRoZSBmaXJzdCBpcyBleHRlbnQgaXMg
cmVhY2hpbmcgdGhlIEVvRiwgbm8gbmVlZCB0byBzaGFyZSAqLw0KPj4gKyBpZiAoY2xvbmUuc3Jj
X29mZnNldCArIGNsb25lLnNyY19sZW5ndGggPj0gZ19kZWZyYWdfZmlsZV9zaXplKQ0KPj4gKyBy
ZXR1cm47DQo+PiArIGVyciA9IGlvY3RsKHNjcmF0Y2hfZmQsIEZJQ0xPTkVSQU5HRSwgJmNsb25l
KTsNCj4+ICsgaWYgKGVyciAhPSAwKSB7DQo+PiArIGZwcmludGYoc3RkZXJyLCAiY2xvbmluZyBm
aXJzdCBleHRlbnQgZmFpbGVkOiAlc1xuIiwNCj4+ICsgc3RyZXJyb3IoZXJybm8pKTsNCj4+ICsg
cmV0dXJuOw0KPj4gKyB9DQo+PiArDQo+PiArIC8qIHNhZmUgdGhlIG9mZnNldCBhbmQgbGVuZ3Ro
IGZvciByZS1zaGFyZSAqLw0KPj4gKyBnX3NoYXJlX29mZnNldCA9IGNsb25lLnNyY19vZmZzZXQ7
DQo+PiArIGdfc2hhcmVfbGVuID0gY2xvbmUuc3JjX2xlbmd0aDsNCj4+ICt9DQo+PiArDQo+PiAr
LyogcmUtc2hhcmUgdGhlIGJsb2NrcyB3ZSBzaGFyZWQgcHJldmlvdXMgaWYgdGhlbiBhcmUgbm8g
bG9uZ2VyIHNoYXJlZCAqLw0KPj4gK3N0YXRpYyB2b2lkDQo+PiArZGVmcmFnX3Jlc2hhcmVfYmxv
Y2tzX2luX2Zyb250KGludCBkZWZyYWdfZmQsIGludCBzY3JhdGNoX2ZkKQ0KPj4gK3sNCj4+ICsj
ZGVmaW5lIE5SX0dFVF9FWFQgOQ0KPj4gKyBzdHJ1Y3QgZ2V0Ym1hcHggbWFweFtOUl9HRVRfRVhU
XTsNCj4+ICsgc3RydWN0IGZpbGVfY2xvbmVfcmFuZ2UgY2xvbmU7DQo+PiArIF9fdTY0IG5ld19z
aGFyZV9sZW47DQo+PiArIGludCBpZHgsIGVycjsNCj4+ICsNCj4+ICsgaWYgKGdfZW5hYmxlX2Zp
cnN0X2V4dF9zaGFyZSA9PSBmYWxzZSkNCj4+ICsgcmV0dXJuOw0KPj4gKw0KPj4gKyBpZiAoZ19z
aGFyZV9sZW4gPT0gMFVMTCkNCj4+ICsgcmV0dXJuOw0KPj4gKw0KPj4gKyAvKg0KPj4gKyAqIGNo
ZWNrIGlmIHByZXZpb3VzIHNoYXJlaW5nIHN0aWxsIGV4aXN0DQo+PiArICogd2UgYXJlIGRvbmUg
aWYgKHBhcnRpYWxseSkgc28uDQo+PiArICovDQo+PiArIG1hcHhbMF0uYm12X29mZnNldCA9IGdf
c2hhcmVfb2Zmc2V0Ow0KPj4gKyBtYXB4WzBdLmJtdl9sZW5ndGggPSBnX3NoYXJlX2xlbjsNCj4+
ICsgbWFweFswXS5ibXZfY291bnQgPSBOUl9HRVRfRVhUOw0KPj4gKyBtYXB4WzBdLmJtdl9pZmxh
Z3MgPSBCTVZfSUZfTk9fSE9MRVMgfCBCTVZfSUZfUFJFQUxMT0M7DQo+PiArIGVyciA9IGlvY3Rs
KGRlZnJhZ19mZCwgWEZTX0lPQ19HRVRCTUFQWCwgbWFweCk7DQo+PiArIGlmIChlcnIpIHsNCj4+
ICsgZnByaW50ZihzdGRlcnIsICJYRlNfSU9DX0dFVEJNQVBYIGZhaWxlZCAlc1xuIiwNCj4+ICsg
c3RyZXJyb3IoZXJybm8pKTsNCj4+ICsgLyogd29uJ3QgdHJ5IHNoYXJlIGFnYWluICovDQo+PiAr
IGdfc2hhcmVfbGVuID0gMFVMTDsNCj4+ICsgcmV0dXJuOw0KPj4gKyB9DQo+PiArDQo+PiArIGlm
IChtYXB4WzBdLmJtdl9lbnRyaWVzID09IDApIHsNCj4+ICsgLyogc2hhcmVkIGJsb2NrcyBhbGwg
YmVjYW1lIGhvbGUsIHdvbid0IHRyeSBzaGFyZSBhZ2FpbiAqLw0KPj4gKyBnX3NoYXJlX2xlbiA9
IDBVTEw7DQo+PiArIHJldHVybjsNCj4+ICsgfQ0KPj4gKw0KPj4gKyBpZiAoZ19zaGFyZV9vZmZz
ZXQgIT0gNTEyICogbWFweFsxXS5ibXZfb2Zmc2V0KSB7DQo+PiArIC8qIGZpcnN0IHNoYXJlZCBi
bG9jayBiZWNhbWUgaG9sZSwgd29uJ3QgdHJ5IHNoYXJlIGFnYWluICovDQo+PiArIGdfc2hhcmVf
bGVuID0gMFVMTDsNCj4+ICsgcmV0dXJuOw0KPj4gKyB9DQo+PiArDQo+PiArIC8qIHdlIGNoZWNr
IHVwIHRvIG9ubHkgdGhlIGZpcnN0IE5SX0dFVF9FWFQgLSAxIGV4dGVudHMgKi8NCj4+ICsgZm9y
IChpZHggPSAxOyBpZHggPD0gbWFweFswXS5ibXZfZW50cmllczsgaWR4KyspIHsNCj4+ICsgaWYg
KG1hcHhbaWR4XS5ibXZfb2ZsYWdzICYgQk1WX09GX1NIQVJFRCkgew0KPj4gKyAvKiBzb21lIGJs
b2NrcyBzdGlsbCBzaGFyZWQsIGRvbmUgKi8NCj4+ICsgcmV0dXJuOw0KPj4gKyB9DQo+PiArIH0N
Cj4+ICsNCj4+ICsgLyoNCj4+ICsgKiBUaGUgcHJldmlvdXNseSBzaGFyZWQgYmxvY2tzIGFyZSBu
byBsb25nZXIgc2hhcmVkLCByZS1zaGFyZS4NCj4+ICsgKiBkZWFsbG9jYXRlIHRoZSBibG9ja3Mg
aW4gc2NyYXRoIGZpbGUgZmlyc3QNCj4+ICsgKi8NCj4+ICsgZXJyID0gZmFsbG9jYXRlKHNjcmF0
Y2hfZmQsDQo+PiArIEZBTExPQ19GTF9QVU5DSF9IT0xFfEZBTExPQ19GTF9LRUVQX1NJWkUsDQo+
PiArIE9GRlNFVF8xUEIgKyBnX3NoYXJlX29mZnNldCwgZ19zaGFyZV9sZW4pOw0KPj4gKyBpZiAo
ZXJyICE9IDApIHsNCj4+ICsgZnByaW50ZihzdGRlcnIsICJwdW5jaCBob2xlIGZhaWxlZCAlc1xu
IiwNCj4+ICsgc3RyZXJyb3IoZXJybm8pKTsNCj4+ICsgZ19zaGFyZV9sZW4gPSAwOw0KPj4gKyBy
ZXR1cm47DQo+PiArIH0NCj4+ICsNCj4+ICsgbmV3X3NoYXJlX2xlbiA9IDUxMiAqIG1hcHhbMV0u
Ym12X2xlbmd0aDsNCj4+ICsgaWYgKG5ld19zaGFyZV9sZW4gPiBTSEFSRV9NQVhfU0laRSkNCj4+
ICsgbmV3X3NoYXJlX2xlbiA9IFNIQVJFX01BWF9TSVpFOw0KPj4gKw0KPj4gKyBjbG9uZS5zcmNf
ZmQgPSBkZWZyYWdfZmQ7DQo+PiArIC8qIGtlZXAgc3RhcnRpbmcgb2Zmc2V0IHVuY2hhbmdlZCAq
Lw0KPj4gKyBjbG9uZS5zcmNfb2Zmc2V0ID0gZ19zaGFyZV9vZmZzZXQ7DQo+PiArIGNsb25lLnNy
Y19sZW5ndGggPSBuZXdfc2hhcmVfbGVuOw0KPj4gKyBjbG9uZS5kZXN0X29mZnNldCA9IE9GRlNF
VF8xUEIgKyBjbG9uZS5zcmNfb2Zmc2V0Ow0KPj4gKw0KPj4gKyBlcnIgPSBpb2N0bChzY3JhdGNo
X2ZkLCBGSUNMT05FUkFOR0UsICZjbG9uZSk7DQo+PiArIGlmIChlcnIpIHsNCj4+ICsgZnByaW50
ZihzdGRlcnIsICJGSUNMT05FUkFOR0UgZmFpbGVkICVzXG4iLA0KPj4gKyBzdHJlcnJvcihlcnJu
bykpOw0KPj4gKyBnX3NoYXJlX2xlbiA9IDA7DQo+PiArIHJldHVybjsNCj4+ICsgfQ0KPj4gKw0K
Pj4gKyBnX3NoYXJlX2xlbiA9IG5ld19zaGFyZV9sZW47DQo+PiArIH0NCj4+ICsNCj4+IC8qDQo+
PiAgKiBkZWZyYWdtZW50IGEgZmlsZQ0KPj4gICogcmV0dXJuIDAgaWYgc3VjY2Vzc2Z1bGx5IGRv
bmUsIDEgb3RoZXJ3aXNlDQo+PiBAQCAtMzc3LDYgKzUyNiwxMiBAQCBkZWZyYWdfeGZzX2RlZnJh
ZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+IA0KPj4gc2lnbmFsKFNJR0lOVCwgZGVmcmFnX3NpZ2lu
dF9oYW5kbGVyKTsNCj4+IA0KPj4gKyAvKg0KPj4gKyAqIHNoYXJlIHRoZSBmaXJzdCBleHRlbnQg
dG8gd29yayBhcm91bmQga2VybmVsIGNvbnN1bWluZyB0aW1lDQo+PiArICogaW4geGZzX3JlZmxp
bmtfdHJ5X2NsZWFyX2lub2RlX2ZsYWcoKQ0KPj4gKyAqLw0KPj4gKyBkZWZyYWdfc2hhcmVfZmly
c3RfZXh0ZW50KGRlZnJhZ19mZCwgc2NyYXRjaF9mZCk7DQo+PiArDQo+PiBkbyB7DQo+PiBzdHJ1
Y3QgdGltZXZhbCB0X2Nsb25lLCB0X3Vuc2hhcmUsIHRfcHVuY2hfaG9sZTsNCj4+IHN0cnVjdCBk
ZWZyYWdfc2VnbWVudCBzZWdtZW50Ow0KPj4gQEAgLTQ1NCw2ICs2MDksMTUgQEAgZGVmcmFnX3hm
c19kZWZyYWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiBpZiAodGltZV9kZWx0YSA+IG1heF91bnNo
YXJlX3VzKQ0KPj4gbWF4X3Vuc2hhcmVfdXMgPSB0aW1lX2RlbHRhOw0KPj4gDQo+PiArIC8qDQo+
PiArICogaWYgdW5zaGFyZSB1c2VkIG1vcmUgdGhhbiAxIHNlY29uZCwgdGltZSBpcyB2ZXJ5IHBv
c3NpYmx5DQo+PiArICogdXNlZCBpbiBjaGVja2luZyBpZiB0aGUgZmlsZSBpcyBzaGFyaW5nIGV4
dGVudHMgbm93Lg0KPj4gKyAqIHRvIGF2b2lkIHRoYXQgaGFwcGVuIGFnYWluIHdlIHJlLXNoYXJl
IHRoZSBibG9ja3MgaW4gZnJvbnQNCj4+ICsgKiB0byB3b3JrYXJvdW5kIHRoYXQuDQo+PiArICov
DQo+PiArIGlmICh0aW1lX2RlbHRhID4gMTAwMDAwMCkNCj4+ICsgZGVmcmFnX3Jlc2hhcmVfYmxv
Y2tzX2luX2Zyb250KGRlZnJhZ19mZCwgc2NyYXRjaF9mZCk7DQo+PiArDQo+PiAvKg0KPj4gKiBQ
dW5jaCBvdXQgdGhlIG9yaWdpbmFsIGV4dGVudHMgd2Ugc2hhcmVkIHRvIHRoZQ0KPj4gKiBzY3Jh
dGNoIGZpbGUgc28gdGhleSBhcmUgcmV0dXJuZWQgdG8gZnJlZSBzcGFjZS4NCj4+IEBAIC01MTQs
NiArNjc4LDggQEAgc3RhdGljIHZvaWQgZGVmcmFnX2hlbHAodm9pZCkNCj4+ICIgLWYgZnJlZV9z
cGFjZSAgICAgIC0tIHNwZWNpZnkgc2hyZXRob2Qgb2YgdGhlIFhGUyBmcmVlIHNwYWNlIGluIE1p
Qiwgd2hlblxuIg0KPj4gIiAgICAgICAgICAgICAgICAgICAgICAgWEZTIGZyZWUgc3BhY2UgaXMg
bG93ZXIgdGhhbiB0aGF0LCBzaGFyZWQgc2VnbWVudHMgXG4iDQo+PiAiICAgICAgICAgICAgICAg
ICAgICAgICBhcmUgZXhjbHVkZWQgZnJvbSBkZWZyYWdtZW50YXRpb24sIDEwMjQgYnkgZGVmYXVs
dFxuIg0KPj4gKyIgLW4gICAgICAgICAgICAgICAgIC0tIGRpc2FibGUgdGhlIFwic2hhcmUgZmly
c3QgZXh0ZW50XCIgZmVhdHVlLCBpdCdzXG4iDQo+PiArIiAgICAgICAgICAgICAgICAgICAgICAg
ZW5hYmxlZCBieSBkZWZhdWx0IHRvIHNwZWVkIHVwXG4iDQo+PiApKTsNCj4+IH0NCj4+IA0KPj4g
QEAgLTUyNSw3ICs2OTEsNyBAQCBkZWZyYWdfZihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+PiBp
bnQgaTsNCj4+IGludCBjOw0KPj4gDQo+PiAtIHdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBhcmd2
LCAiczpmOiIpKSAhPSBFT0YpIHsNCj4+ICsgd2hpbGUgKChjID0gZ2V0b3B0KGFyZ2MsIGFyZ3Ys
ICJzOmY6biIpKSAhPSBFT0YpIHsNCj4+IHN3aXRjaChjKSB7DQo+PiBjYXNlICdzJzoNCj4+IGdf
c2VnbWVudF9zaXplX2xtdCA9IGF0b2kob3B0YXJnKSAqIDEwMjQgKiAxMDI0IC8gNTEyOw0KPj4g
QEAgLTUzOSw2ICs3MDUsMTAgQEAgZGVmcmFnX2YoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPj4g
Z19saW1pdF9mcmVlX2J5dGVzID0gYXRvbChvcHRhcmcpICogMTAyNCAqIDEwMjQ7DQo+PiBicmVh
azsNCj4+IA0KPj4gKyBjYXNlICduJzoNCj4+ICsgZ19lbmFibGVfZmlyc3RfZXh0X3NoYXJlID0g
ZmFsc2U7DQo+PiArIGJyZWFrOw0KPj4gKw0KPj4gZGVmYXVsdDoNCj4+IGNvbW1hbmRfdXNhZ2Uo
JmRlZnJhZ19jbWQpOw0KPj4gcmV0dXJuIDE7DQo+PiBAQCAtNTU2LDcgKzcyNiw3IEBAIHZvaWQg
ZGVmcmFnX2luaXQodm9pZCkNCj4+IGRlZnJhZ19jbWQuY2Z1bmMgPSBkZWZyYWdfZjsNCj4+IGRl
ZnJhZ19jbWQuYXJnbWluID0gMDsNCj4+IGRlZnJhZ19jbWQuYXJnbWF4ID0gNDsNCj4+IC0gZGVm
cmFnX2NtZC5hcmdzID0gIlstcyBzZWdtZW50X3NpemVdIFstZiBmcmVlX3NwYWNlXSI7DQo+PiAr
IGRlZnJhZ19jbWQuYXJncyA9ICJbLXMgc2VnbWVudF9zaXplXSBbLWYgZnJlZV9zcGFjZV0gWy1u
XSI7DQo+PiBkZWZyYWdfY21kLmZsYWdzID0gQ01EX0ZMQUdfT05FU0hPVDsNCj4+IGRlZnJhZ19j
bWQub25lbGluZSA9IF8oIkRlZnJhZ21lbnQgWEZTIGZpbGVzIik7DQo+PiBkZWZyYWdfY21kLmhl
bHAgPSBkZWZyYWdfaGVscDsNCj4+IC0tIA0KPj4gMi4zOS4zIChBcHBsZSBHaXQtMTQ2KQ0KPj4g
DQo+PiANCg0K

