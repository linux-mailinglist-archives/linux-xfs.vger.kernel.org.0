Return-Path: <linux-xfs+bounces-588-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5ABF80B322
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Dec 2023 09:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50B8C1F21294
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Dec 2023 08:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FBE79C0;
	Sat,  9 Dec 2023 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iy/OVlRw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142F137;
	Sat,  9 Dec 2023 00:17:55 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7b459364167so101269239f.2;
        Sat, 09 Dec 2023 00:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702109874; x=1702714674; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vw90yWCuaFmFuU5ynluaqiB/yx3h4VMDt+wN5n9OLZo=;
        b=Iy/OVlRwshQzUTtWU/6YkQlBVQndchtPGKn5LPQOTU+UtzmRMl9BheydRFfJjxY0ki
         NgjIGjpicQrVz/ThjyDFkgfQkxR6fS8IDBHEdEBCFUxSbwRXlGNSXZxUrsrgRPW3dGcc
         OrPYADILpBWM7Opa68JLHD2f5F7pvu+X6Diquvn6KdgXyzEiCbCBovwtO+xuTys4V6nR
         Nmp3bGcTuRZOIP+n8tascYPr3ZZBs72LYArpLYilNOkEUcq/Y0KMAny+L11nUcPSmqOl
         +DoeWdQGuROUjS4noksrVt7oNB950jWvMIbFqtn2ifkqLROERuby+t+LWzOX+a5jqazh
         3pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702109874; x=1702714674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vw90yWCuaFmFuU5ynluaqiB/yx3h4VMDt+wN5n9OLZo=;
        b=FiirOgqac7w/5p182w4onO4gLHGHIDOo7HLNW96NJkFOcnyI+30n4jm7+vPDjDXPiF
         o37ePyG5XeGpK4yKMZn/gp8BudkFDrNsP/Z2MkT0DlQrg4w4NyjaimDMvUzlvmhFnUYW
         /gg0IUGc10of5HNKZAytsHT3mZcC/Z6MtCBQrt9iGntOdKgaXA1p+7f1SiHbsng1rtnv
         SH95B+JlKedCoTTuvSHndFYlsTKzXv37MupmH/Z83US48Sbg356eoUhx8hVMjWpvVgaV
         JNYS4nL11zYgCjlDokvh0/Xw2Oaidc5a1FcndI3K9U4zcSKJjoN1BQ30RTqwipMOMzNG
         gXzA==
X-Gm-Message-State: AOJu0YzSs+bhVcKJo0ZUOcAjEjSbCtGI+jusaUd/XPHJFfY/mxgABjsV
	ZTITDdvP40cBKcwPoyU/HFc=
X-Google-Smtp-Source: AGHT+IH+cfKMv3xgzol2WOJ5lHJEvCMIaTKT9Wtn+aUdjQMts0DLGgqa340rZK08kW9nmq1E578iKQ==
X-Received: by 2002:a05:6e02:16cb:b0:35d:9344:b033 with SMTP id 11-20020a056e0216cb00b0035d9344b033mr1454323ilx.12.1702109874647;
        Sat, 09 Dec 2023 00:17:54 -0800 (PST)
Received: from [192.168.0.106] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id k10-20020a170902694a00b001d1c96a0c63sm2863886plt.274.2023.12.09.00.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 00:17:54 -0800 (PST)
Message-ID: <9573bd00-7b9e-40d0-9229-f273bf4e6a16@gmail.com>
Date: Sat, 9 Dec 2023 15:17:29 +0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] Documentation: xfs: consolidate XFS docs into its own
 subdirectory
Content-Language: en-US
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, "Darrick J. Wong" <djwong@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux XFS <linux-xfs@vger.kernel.org>,
 Linux Kernel Workflows <workflows@vger.kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Dave Chinner <dchinner@redhat.com>,
 Steve French <stfrench@microsoft.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Allison Henderson <allison.henderson@oracle.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Charles Han <hanchunchao@inspur.com>,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <20231129123947.4706-1-bagasdotme@gmail.com>
 <ZXP6kzbfUcLbBtCi@archie.me>
 <874jgryf8d.fsf@debian-BULLSEYE-live-builder-AMD64>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <874jgryf8d.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/9/23 15:00, Chandan Babu R wrote:
> On Sat, Dec 09, 2023 at 12:26:43 PM +0700, Bagas Sanjaya wrote:
>> [[PGP Signed Part:No public key for F6B9894955514EA3 created at 2023-12-09T10:56:39+0530 using EDDSA]]
>> On Wed, Nov 29, 2023 at 07:39:47PM +0700, Bagas Sanjaya wrote:
>>> XFS docs are currently in upper-level Documentation/filesystems.
>>> Although these are currently 4 docs, they are already outstanding as
>>> a group and can be moved to its own subdirectory.
>>>
>>> Consolidate them into Documentation/filesystems/xfs/.
>>>
>>> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
>>
>> Hi Jon, Chandan, and Darrick,
>>
>> FYI, XFS tree [1] is not updated since 2 weeks ago (and this patch doesn't get
>> picked up). Would you like to route this patch through docs-next tree or
>> xfs/for-next?
>>
> 
> This patch is part of a collection of patches that I am planning to include in
> the pull request for v6.8-rc1. I am currently running fstests to make sure
> that there are no regressions.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara


