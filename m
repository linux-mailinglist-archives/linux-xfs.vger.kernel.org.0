Return-Path: <linux-xfs+bounces-11868-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D12895ACD8
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2024 07:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 185B4283883
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2024 05:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1EE3EA86;
	Thu, 22 Aug 2024 05:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjRLjedU"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3AC36B11
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 05:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724304456; cv=none; b=lxrYsBULjNL5orbKAy8bdNOrp2JdRDA+DT6Qu318L90yBVESq9mrChZar9ixBKCRnymAeI4YIRfoBEyqskm5pwuSTuCmkTjVRPpLVAuj2hfcHJqVtsgW0n6WYTdXAClZt5cln1YiJ8egLDtAD4zYHwXaVCxKyxuwm5TcH0AVcmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724304456; c=relaxed/simple;
	bh=Cki+Mu0/zQdsJP2Tc4jU0SSghDoUko51TtU5PBBEYuI=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=lxagEegUFVY59iJdpGXTcqwnorek3y50rTmMAneghlSZThFo9aF/Remr3k8bEYPHE95TxuGHu6eTT2fa8fAoAF0qUeFMTwfJuMz7Cx7F95O19AN8uwYkN6VaifJaD0A67BaqUmcQ0oqB/iHKTaaMRC61AfD/hQo2BlvRxSvJ6d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjRLjedU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF55CC4AF09;
	Thu, 22 Aug 2024 05:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724304456;
	bh=Cki+Mu0/zQdsJP2Tc4jU0SSghDoUko51TtU5PBBEYuI=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=PjRLjedUXZ80gPRtU4d5lauZNTSuBEfnfZDI+wxTOTqV/K1UZ2NNLlfYby9caaJDy
	 pbmSNgCZbPu6By+1Hc3JirvdsV/+QZT1uLWEnjF4PQVnJqxfkoKj2guWOxnAjZ27cJ
	 Wof0Trpt7s2NOIBNRygapcQGGrFgaLOPQ2qGacxdAKMsnQ9LbGCOLFmTVJAiXcgsg9
	 4cxw5MBIO5IwZ7655sdBwId62Vg1l0MlK/FUPWxyEk1sT07To+QZskJUpAz8/5q3wW
	 Ds9RVvKLDE0OWqfYO+FgzWicYyLY6a/MXahkQYLVnRX6zEpEqJarnzaUzR5C6GM1Hr
	 rqY+Fhry+aEvA==
References: <20240812224009.GD6051@frogsfrogsfrogs>
 <ZrrzUw55-UQZ649j@infradead.org> <20240822050442.GO865349@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, kjell.m.randa@gmail.com, xfs
 <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Date: Thu, 22 Aug 2024 10:55:05 +0530
In-reply-to: <20240822050442.GO865349@frogsfrogsfrogs>
Message-ID: <87r0ah6saj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 21, 2024 at 10:04:42 PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 12, 2024 at 10:46:59PM -0700, Christoph Hellwig wrote:
>> Looks good:
>> 
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Hey Chandan, I just realized this didn't get merged yet, even though
> there's a user complaint about this.  Can we get this staged for 6.11,
> please?

Sorry, I missed this patch. I have started running tests on "v6.11-rc4 +
<this patch>".  However, the earliest I could send the pull request is
sometime next week.

-- 
Chandan

