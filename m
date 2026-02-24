Return-Path: <linux-xfs+bounces-31242-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPS3K5BonWnBPwQAu9opvQ
	(envelope-from <linux-xfs+bounces-31242-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 10:00:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F208184232
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 09:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1236B31AA9F8
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 08:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF51336681D;
	Tue, 24 Feb 2026 08:55:07 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16CF369211
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771923307; cv=none; b=OuiamC1/gIyq3QtVjk5qCPHxtxsqIk9XJ37kxl/HjC38vUcU3+ac0oLTYQsMV3dE3KYVnrOLodqaINiUvSIlvWVRBeFneo0SSwH8KoRZQhIwfDzX7P9AsJRJ+S2mFriXfiumRtN/QL8QrcqpmUNoPCSxGc20EIWYXBgxS58i2y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771923307; c=relaxed/simple;
	bh=WdkXRdY3pya96/6gahFL70Y8QYuUJkziwiUDKY2Gu+w=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Lcoey0w6z8JXVazJ4UsiJx69f1OkRWY42zT1bvpsF0mlr3vquNV5ilvsjmMQgyXlXjnFKhmPrzw/QsK4zJ5QzC6HXG1C9vB1WFkCqRNtOjbw4smt9ZuoghL+jUJazEzGlB+za35vql9GzNt8IKqdGc5mgH5NLrsUTQcLWEjDjPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 35AEE180F24F;
	Tue, 24 Feb 2026 09:54:59 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id JRXkAmNnnWlshQ4AKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 24 Feb 2026 09:54:59 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 09:54:58 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v9] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <20260223161915.GA2390353@frogsfrogsfrogs>
References: <20260223091106.296338-2-lukas@herbolt.com>
 <20260223161915.GA2390353@frogsfrogsfrogs>
Message-ID: <18da9d56003f68d964e8de66d75b1476@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[herbolt.com];
	TAGGED_FROM(0.00)[bounces-31242-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas@herbolt.com,linux-xfs@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.961];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,herbolt.com:mid,herbolt.com:email]
X-Rspamd-Queue-Id: 0F208184232
X-Rspamd-Action: no action

On 2026-02-23 17:19, Darrick J. Wong wrote:
> On Mon, Feb 23, 2026 at 10:11:07AM +0100, Lukas Herbolt wrote:
>> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
>> the unmap write zeroes operation.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  fs/xfs/xfs_bmap_util.c |  5 +++--
>>  fs/xfs/xfs_bmap_util.h |  2 +-
>>  fs/xfs/xfs_file.c      | 39 ++++++++++++++++++++++++++-------------
>>  3 files changed, 30 insertions(+), 16 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 2208a720ec3f..0c1b1fa82f8b 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -646,7 +646,8 @@ int
>>  xfs_alloc_file_space(
>>  	struct xfs_inode	*ip,
>>  	xfs_off_t		offset,
>> -	xfs_off_t		len)
>> +	xfs_off_t		len,
>> +	uint32_t		bmapi_flags)
>>  {
>>  	xfs_mount_t		*mp = ip->i_mount;
>>  	xfs_off_t		count;
>> @@ -748,7 +749,7 @@ xfs_alloc_file_space(
>>  		 * will eventually reach the requested range.
>>  		 */
>>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
>> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>>  				&nimaps);
>>  		if (error) {
>>  			if (error != -ENOSR)
>> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
>> index c477b3361630..2895cc97a572 100644
>> --- a/fs/xfs/xfs_bmap_util.h
>> +++ b/fs/xfs/xfs_bmap_util.h
>> @@ -56,7 +56,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, 
>> struct xfs_inode *ip,
>> 
>>  /* preallocation and hole punch interface */
>>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
>> -		xfs_off_t len);
>> +		xfs_off_t len, uint32_t bmapi_flags);
>>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 7874cf745af3..83c45ada3cc8 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1293,6 +1293,7 @@ xfs_falloc_zero_range(
>>  	unsigned int		blksize = i_blocksize(inode);
>>  	loff_t			new_size = 0;
>>  	int			error;
>> +	uint32_t                bmapi_flags;
>> 
>>  	trace_xfs_zero_file_space(ip);
>> 
>> @@ -1300,18 +1301,27 @@ xfs_falloc_zero_range(
>>  	if (error)
>>  		return error;
>> 
>> -	if (xfs_falloc_force_zero(ip, ac)) {
>> -		error = xfs_zero_range(ip, offset, len, ac, NULL);
>> -	} else {
>> -		error = xfs_free_file_space(ip, offset, len, ac);
> 
> Where did this call to xfs_free_file_space go?  This looks like a
> behavior change in the classic zero-range behavior.
> 
> --D
> 

Seems I missed the else branch when doing the rebase.
-- 
-lhe

