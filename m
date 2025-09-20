Return-Path: <linux-xfs+bounces-25857-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB43B8BF21
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Sep 2025 06:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCFC65A2722
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Sep 2025 04:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551D222F755;
	Sat, 20 Sep 2025 04:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLuGppCK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE62AD24
	for <linux-xfs@vger.kernel.org>; Sat, 20 Sep 2025 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758342690; cv=none; b=IOH3pBKWwKPnwdwC26SOX7swLAUET9GUdwlgUvxK0e0dwEQeqhGzb7roYjonGjTECh8jXjma9L7OxEcl5rfmVh/uO24mQW5Rf0ABVK/nO6EEup+K+iFG+3VvDwgNBWzzvRkuspx6ojBqqxjaRnZ35bWsxz6PZsSn2IcZ5n/9ZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758342690; c=relaxed/simple;
	bh=kAny4aRymFDIo+7FPT/ml2qL4nKq50MkuxSYtUo1xdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eCBVnMBwK9PlQOFwbuTHtQjNxQpOJJ6aaoffMKYOscfVTBTkGsa1yD4PdjZWqokIR3Isn3gPBpg8C3+YpJ4QwgDbAxcWyAykSUT3D87/tNF9ldkQ0xXsV8vON7RvupDMzRKj790p4kR/yLP0EyJ9jlHJlk8B5OZNvn5l6aYDhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLuGppCK; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-42485372dc6so9459005ab.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758342686; x=1758947486; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=fLuGppCK4DAjqW2augM3XZ8Si1RMcFrTAkhTtUvRhH0k/DXAIsFNsnQe33qYOjkDng
         nNwrfJWpcAk++ei1tdRu0b/xa/dqgXyvawOXT8SsK/3ZzsRHv1grK/yp2oAR8fVcAXwR
         aPLMAYcsE04tGb7zBj/O6Qr417zM0P4kI/UM02G3avJZ5HQDfbHVXmexAcnnqoce6IS2
         9FBhY/pEVVjVVg5xdbQ9mKV3F8F4pQOU6bNtMts9IsOZfNrtNgB2MR2fO9OUWzHlSwGv
         rXbKeVem2CeEgaM0ME0xcM9hP7hYEEqA6iIC8ZpUfEdjXSYAS+7rUZe5/gatEBHDMS+Y
         mUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758342686; x=1758947486;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=Hu347QkEs4rkeSzgB++/LElHxf6tM2QLpldmZwzg1xrpS+vmFs9CQf8+cxtTks/a2y
         5mul+ObsD9QrkNMKtAKOItiJk5guTshcK9DgdrRQCIAfMTYVezqgljiSQmoPoaw3O+Di
         FdzCJBteZD9c08/UH0B0p4q4jJmeAbXIyUEx7YHeIeBeRqgkAYBTqRoszH3qnR0pGb0G
         mu9/NRmhd2ztC8k9QtV+SLrHcm6KbAzkfjoV3om0UrIqogjg4nnjSucsUrHEAYu5a24e
         RnHGirYHyzmlXufJbGhWAVmF1LNV+t1dfa+f1BHuto4qXiw3hDw8fmd5Nq31lRzyvpwR
         iHHw==
X-Forwarded-Encrypted: i=1; AJvYcCV+V9Iv1ibPRiluSA0k+a0pndIcp2udhEfaQmFTpgIIvO2hgEW8s0wtSuafIAKuLYXsE5sn7CKWJbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxfWuGESRXqZZr2W3nr74To/GgC+W9IgN9p90DMP6E7yMdKhYN
	0W5egp+j+JzwPjqbCVPCCmFE9NtPUNzQYJElXR0Aut3gCfkXLyGxNaDU
X-Gm-Gg: ASbGncscZBBRnzruG+HC12UwTLhwB6Y4yMMTlxUziAaFmVU7DeekPIGIz+d80mlS9F9
	X3c2ydQOGlXt+y+1EuBpmFiOkcNQMGA3myuFNMbleHak0JLRn9kRGZInAfiPNaWkLhKxshwO3Vs
	L01u4+AcCoGQgQQuiz23V2A8aUY1d8P/uzfreXnbwb+rEsxlIMZESb5BYS+ilusMAtr/bBaBgTn
	kllH1jkCnX+4v295R8O302YeCTrzUtVqyYeGR1vihWRZhhDOJbWjj9fZFX7e5Lpm64fM8phX9km
	joIKZOShNWJd4Ks8Iois/mDkamcfpe6Lih3rL+DzNI295/9GUPEmUws6Tsw/YIycvkNHunpk9z0
	ZTG9itvHq26ScmMvBv1iWDxa8jPzNtfvPKbqmzA==
X-Google-Smtp-Source: AGHT+IFcG4QqJ4nlgO3oq0I1YnwOZ/K7SIrMHUnkDcvBmlrkEhfFU8B8mZqzq5hu5cnZ8bWVDrbaVA==
X-Received: by 2002:a05:6e02:156b:b0:424:30f:8e7c with SMTP id e9e14a558f8ab-42481909f5emr98881625ab.10.1758342686244;
        Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
Received: from ?IPV6:2600:6c56:7d00:582f::64e? ([2600:6c56:7d00:582f::64e])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-53d56e429f3sm2997444173.74.2025.09.19.21.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 21:31:24 -0700 (PDT)
Message-ID: <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
Date: Fri, 19 Sep 2025 23:31:22 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] hide ->i_state behind accessors
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com,
 amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-unionfs@vger.kernel.org
References: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Language: en-US
From: Russell Haley <yumpusamongus@gmail.com>
In-Reply-To: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 10:49 AM, Mateusz Guzik wrote:
> This is generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries
> 
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state  	=> state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
> inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)
> [/quote]

Drive-by bikeshedding: s/set/replace/g

"replace" removes ambiguity with the concept of setting a bit ( |= ). An
alternative would be "set_only".


