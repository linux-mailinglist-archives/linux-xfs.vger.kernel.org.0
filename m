Return-Path: <linux-xfs+bounces-31315-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sDOMCN8NoGnbfQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31315-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 10:09:51 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEEE1A32C1
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 10:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ECD5A3004C09
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Feb 2026 09:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4574E38759F;
	Thu, 26 Feb 2026 09:08:09 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0C321ADC7
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772096889; cv=none; b=qH/2iz3FxcG6x4SUBd3LTNVzKJQTyGvThQiz8ERx3wy2X9u8rSfYnXmZtNygGRGyHuLfFHEKEwdqRKHCC/xtf+AHaywus9AU8OhaQdu9KMW2iJ6Llwuc1JDVXBQYH29GDKwCaST1GzWBb9x38YMtmrRnJboZ5TGa0844pCFEImI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772096889; c=relaxed/simple;
	bh=/4+FEFe8mFJZSNgJAbPxiLjUZCswXlBZkpSFF4RvsPw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=T6TiGff/9h6ZSieObl5CFnPwXAVHx1cm+i5GD8n6irdeMcV/+wcvd3hdqMR3ni6niF3orXxktEfs0zu1CH543MGMz/temvozHSr8Uc/CKibWcGtDuykNf9vAh6E1oxclifDeojBflljdBNQPuyz7B6Tdj70VszqpZITePY3tQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 87FF0180F243;
	Thu, 26 Feb 2026 10:07:54 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id UwWBHmoNoGlj2hAAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 26 Feb 2026 10:07:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 26 Feb 2026 10:07:54 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Use xarray to track SB UUIDs instead of plain
 array.
In-Reply-To: <aZ8IR37gQkhomIWq@infradead.org>
References: <20260225123322.631159-3-lukas@herbolt.com>
 <aZ8IR37gQkhomIWq@infradead.org>
Message-ID: <6088f873f95cf38e1f125dad2224c52e@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[herbolt.com];
	TAGGED_FROM(0.00)[bounces-31315-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas@herbolt.com,linux-xfs@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8FEEE1A32C1
X-Rspamd-Action: no action

On 2026-02-25 15:33, Christoph Hellwig wrote:
> This doens't apply to current mainline or the XFS tree, as it
> doesn't have the healthmon pointer in the mount structure yet.
> 
>> +/*
>> + * Helper fucntions to store UUID in xarray.
> 
> s/fucntions/functions/
> 
> But I'd just drop the comment.
> 
>> + */
>> +static int
>> +xfs_uuid_insert(
>> +	uuid_t		*uuid,
>> +	unsigned int	*index)
>> +{
>> +	return xa_alloc(&xfs_uuid_table, index, uuid,
>> +			xa_limit_32b, GFP_KERNEL);
>> +}
> 
> ... and open code this in the only caller.
> 
>> +static void
>> +xfs_uuid_delete(
>> +	uuid_t		*uuid,
>> +	unsigned int	index)
>> +{
>> +	ASSERT(uuid_equal(xa_load(&xfs_uuid_table, index), uuid));
>> +	xa_erase(&xfs_uuid_table, index);
>> +}
> 
>>  	mutex_unlock(&xfs_uuid_table_mutex);
> 
> This looks like it should be a lock and not unlock?
> 
>> +	if (unlikely(xfs_uuid_search(uuid))) {
>> +		xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount",
>> +				uuid);
>> +		return -EINVAL;
> 
> And this is missing an unlock?
> 
> Just curious how this was tested?  xfs/045 should cover mounting with
> duplicate uuids.

I wrote my own simple test I will also try the xfs/045. As always thanks 
for the
notes, will fix it!.
-- 
-lhe

