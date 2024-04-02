Return-Path: <linux-xfs+bounces-6154-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE7E894FA6
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Apr 2024 12:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D55FB20F2B
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Apr 2024 10:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B80E58AAF;
	Tue,  2 Apr 2024 10:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSQLUx/0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773C959151
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 10:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712052711; cv=none; b=FhSDrRodix/BX9pWCdoasGMeG9HZiQXIBNXAaaAxBI+EVOVTHlcLIvRDcIxDLf1CQGvNzS0q0qxxFVFh4baM8cug0DqtIirNaLH0NCGRY/Y/7j5g2yoYRapC0KpC/PXvOXYEAApFK2UlAtP0mmSSXhucWPoUc3oLnZ9k5QgDJGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712052711; c=relaxed/simple;
	bh=oZZKISQHCkrhZ3u+KHXv2WzzLIaOCG06G8lFEDVCZx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S26ThNwgiRaPY8ha3vs4OFpgm4N+wwlO78BnWafMKJaVZdvhyLsheAKlu1/mcpf2p3aCYVYjF6Z+mM5MZa5TDhcKf7a4b84eOdqArPnrXJn6eyjMp05YlNLvnNyxBB2zpbuR2zAYUN0ddMTOKrNDNdL/htl7XcBFWv23fim82AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSQLUx/0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712052708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8orag78Onu0GAnEHG0xqHWizNVsLLZWgOVAfNSrOVdQ=;
	b=JSQLUx/0oyII5W4NhZefFS5gJO/4qteyCqJd3w27s+j4j51ixlngaPxTRscCDg4hKIjnbE
	TRfcEYO29r8pdASKxOoz3mRFU3Kj/RAfA67xsDIxOD7PNzV8m6vroIpUXadQhtjxRHPop5
	AZoea0u+HhApVjvmlowTT0mnChRbBqc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-ijlBNnw1OaiKPmSUBYdg_A-1; Tue, 02 Apr 2024 06:11:47 -0400
X-MC-Unique: ijlBNnw1OaiKPmSUBYdg_A-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a45acc7f191so349683166b.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 03:11:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712052706; x=1712657506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8orag78Onu0GAnEHG0xqHWizNVsLLZWgOVAfNSrOVdQ=;
        b=SrM9VjCx0Sxaon+tx61kaGY4W3YzlIIKZH5LLCwklFaoqFtbf4z4F9ZxBQ9GGwPukR
         i0QKchE+tbwVTbwgaPyziyG1yxeEVhaPZqguZ6rRA36GeDJhW8GMg3sEGyHDfaRTnWGP
         96I4XxFo+cS7hFxPyTAcrXmMeHqvfSfK1tOwX7fsQI08J/IUbbWaMbd77sA7bnszjdcP
         6ZtPfCaTe5W+h+WwetwQoaIDrm1TIspb53vOXYzgPpMIe5kD2dv+bIKHn+LDQdl1+GiA
         GzLIUkTMZhESnoop0ovdjBC1/5Zf8mYIXTign6kV48k0JWc2k9sOH0/xHkRrOwF+0oNe
         O/3g==
X-Forwarded-Encrypted: i=1; AJvYcCUzAiiXmKTx9w1yImhsCAGxjnY2jxILFnuMh2VKnAtqe3VHFhuKfN2sX+5jrIsflvIjevLVCfUtN19yMvn4sTe31KNbBZvRB7qU
X-Gm-Message-State: AOJu0YztAu4OXQYMdraIh38f/h3Pz1+m/PPgQpYJrPxKUfcq2sv1khxG
	FZ3qRpe+RdlZEO4bcH4nMoq/yAbzQlygcOnGsucrZ1z6k+5aiQlKOIfODKktsd5RiaK5cG5ooGt
	DMz6wl2XeJypYmGld4cTJL5OY0uo886O3Wj4DOvBK3xbh8nqyexB9xjG80sx0Xfja
X-Received: by 2002:a17:907:97c9:b0:a4e:5088:a959 with SMTP id js9-20020a17090797c900b00a4e5088a959mr7941030ejc.17.1712052705920;
        Tue, 02 Apr 2024 03:11:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE41BTVXEvs87C4g9qG9R7fbvM19lrF8k4VutiO9eGKUH1kUl1mTLBx9qRMEitVDjuOVUJp8g==
X-Received: by 2002:a17:907:97c9:b0:a4e:5088:a959 with SMTP id js9-20020a17090797c900b00a4e5088a959mr7940989ejc.17.1712052705312;
        Tue, 02 Apr 2024 03:11:45 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id dp12-20020a170906c14c00b00a473a1fe089sm6354140ejc.1.2024.04.02.03.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 03:11:45 -0700 (PDT)
Date: Tue, 2 Apr 2024 12:11:44 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 04/29] xfs: minor cleanups of xfs_attr3_rmt_blocks
Message-ID: <uevz4uxzbgos2zgffvqgjfxyycbwddyq26wli7l2ufvq33qqic@rpy5vxr2nuqn>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868626.1988170.3178382336043313130.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868626.1988170.3178382336043313130.stgit@frogsfrogsfrogs>

On 2024-03-29 17:37:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up the type signature of this function since we don't have
> negative attr lengths or block counts.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey


