Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D076C1F4CC
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfEOMtV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 08:49:21 -0400
Received: from sandeen.net ([63.231.237.45]:41340 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEOMtV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:49:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 99521116F4;
        Wed, 15 May 2019 07:49:03 -0500 (CDT)
Subject: Re: [PATCH 11/11] libxfs: minor sync-ups to kernel-ish functions
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-12-git-send-email-sandeen@redhat.com>
 <20190515062522.GZ29573@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <50fca55e-539f-9ff1-0945-15c366e82001@sandeen.net>
Date:   Wed, 15 May 2019 07:49:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515062522.GZ29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/15/19 1:25 AM, Dave Chinner wrote:
> On Fri, May 10, 2019 at 03:18:30PM -0500, Eric Sandeen wrote:
>> Change typedefs to structs, add comments, and other very
>> minor changes to userspace libxfs/ functions so that they
>> more closely match kernelspace.  Should be no functional
>> changes.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Ah, there's the typedef removal....
> 
> ....
>>  /*
>>   * Free the transaction structure.  If there is more clean up
>>   * to do when the structure is freed, add it here.
>>   */
>> -static void
>> +STATIC void
>>  xfs_trans_free(
>>  	struct xfs_trans	*tp)
>>  {
>> @@ -106,7 +102,7 @@ xfs_trans_reserve(
>>  	uint			blocks,
>>  	uint			rtextents)
>>  {
>> -	int			error = 0;
>> +	int		error = 0;
>>  
>>  	/*
>>  	 * Attempt to reserve the needed disk blocks by decrementing
>> @@ -114,8 +110,9 @@ xfs_trans_reserve(
>>  	 * fail if the count would go below zero.
>>  	 */
>>  	if (blocks > 0) {
>> -		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
>> +		if (tp->t_mountp->m_sb.sb_fdblocks < blocks) {
>>  			return -ENOSPC;
>> +		}
>>  		tp->t_blk_res += blocks;
>>  	}
> 
> These seem a bit weird by themselves. I know, the kernel code has
> more code in the branches and this reduces the diff a bit, but
> it does look a inconsistent now...

The goal would be to add the other bits back in later.  But doing it
in small steps like this just causes confusion, I guess?

>> @@ -235,18 +233,24 @@ xfs_trans_alloc_empty(
>>   * Record the indicated change to the given field for application
>>   * to the file system's superblock when the transaction commits.
>>   * For now, just store the change in the transaction structure.
>> + *
>>   * Mark the transaction structure to indicate that the superblock
>>   * needs to be updated before committing.
>> - *
>> - * Originally derived from xfs_trans_mod_sb().
>>   */
>>  void
>>  xfs_trans_mod_sb(
>> -	xfs_trans_t		*tp,
>> -	uint			field,
>> -	long			delta)
>> +	xfs_trans_t	*tp,
> 
> typedef removal :)
> 
> Kernel side, too, I guess...

Right, the goal here is to sync up with the kernel, not diverge more.

>>  
>> -xfs_buf_t *
>> +/*
>> + * Get and lock the buffer for the caller if it is not already
>> + * locked within the given transaction.  If it is already locked
>> + * within the transaction, just increment its lock recursion count
>> + * and return a pointer to it.
>> + *
>> + * If the transaction pointer is NULL, make this just a normal
>> + * get_buf() call.
>> + */
>> +struct xfs_buf *
>>  xfs_trans_get_buf_map(
>> -	xfs_trans_t		*tp,
>> -	struct xfs_buftarg	*btp,
>> +	struct xfs_trans	*tp,
>> +	struct xfs_buftarg	*target,
>>  	struct xfs_buf_map	*map,
>>  	int			nmaps,
>> -	uint			f)
>> +	uint			flags)
>>  {
>>  	xfs_buf_t		*bp;
> 
> You missed a typedef.

kernel missed a typedef ;)

[sandeen@sandeen linux-xfs]$ grep -A7 ^xfs_trans_get_buf_map fs/xfs/*.c fs/xfs/*/*.c
fs/xfs/xfs_trans_buf.c:xfs_trans_get_buf_map(
fs/xfs/xfs_trans_buf.c-	struct xfs_trans	*tp,
fs/xfs/xfs_trans_buf.c-	struct xfs_buftarg	*target,
fs/xfs/xfs_trans_buf.c-	struct xfs_buf_map	*map,
fs/xfs/xfs_trans_buf.c-	int			nmaps,
fs/xfs/xfs_trans_buf.c-	xfs_buf_flags_t		flags)
fs/xfs/xfs_trans_buf.c-{
fs/xfs/xfs_trans_buf.c-	xfs_buf_t		*bp;

>>  
>> +/*
>> + * Get and lock the superblock buffer of this file system for the
>> + * given transaction.
>> + *
>> + * We don't need to use incore_match() here, because the superblock
>> + * buffer is a private buffer which we keep a pointer to in the
>> + * mount structure.
>> + */
>>  xfs_buf_t *
> 
> typedef
> 
>>  xfs_trans_getsb(
>>  	xfs_trans_t		*tp,
> 
> Another
> 
>> -	xfs_mount_t		*mp,
>> +	struct xfs_mount	*mp,
>>  	int			flags)
>>  {
>>  	xfs_buf_t		*bp;
> 
> And another.
> 
> yup, kernel code needs fixing, too.

"you go first!" ;)

> .....
>> + * transaction began, then also free the buf_log_item associated with it.
>> + *
>> + * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
>> + */
>>  void
>>  xfs_trans_brelse(
>> -	xfs_trans_t		*tp,
>> -	xfs_buf_t		*bp)
>> +	struct xfs_trans	*tp,
>> +	struct xfs_buf		*bp)
>>  {
>> -	xfs_buf_log_item_t	*bip;
>> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>>  #ifdef XACT_DEBUG
>>  	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
>>  #endif
>>  
>> -	if (tp == NULL) {
>> +	if (!tp) {
>>  		ASSERT(bp->b_transp == NULL);
>>  		libxfs_putbuf(bp);
>>  		return;
>>  	}
>>  	ASSERT(bp->b_transp == tp);
>> -	bip = bp->b_log_item;
>>  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
>> +
>> +	/*
>> +	 * If the release is for a recursive lookup, then decrement the count
>> +	 * and return.
>> +	 */
>>  	if (bip->bli_recur > 0) {
>>  		bip->bli_recur--;
>>  		return;
>>  	}
>> -	/* If dirty/stale, can't release till transaction committed */
>> -	if (bip->bli_flags & XFS_BLI_STALE)
>> -		return;
>> +
>> +	/*
>> +	 * If the buffer is invalidated or dirty in this transaction, we can't
>> +	 * release it until we commit.
>> +	 */
>>  	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
>>  		return;
>> +	if (bip->bli_flags & XFS_BLI_STALE)
>> +		return;
> 
> THis is a change of behaviour for userspace, right? What does
> checking for a dirty log item do?

No, it just re-orders an existing test, look up a few lines.

>> +/*
>> + * Invalidate a buffer that is being used within a transaction.
>> + *
>> + * Typically this is because the blocks in the buffer are being freed, so we
>> + * need to prevent it from being written out when we're done.  Allowing it
>> + * to be written again might overwrite data in the free blocks if they are
>> + * reallocated to a file.
>> + *
>> + * We prevent the buffer from being written out by marking it stale.  We can't
>> + * get rid of the buf log item at this point because the buffer may still be
>> + * pinned by another transaction.  If that is the case, then we'll wait until
>> + * the buffer is committed to disk for the last time (we can tell by the ref
>> + * count) and free it in xfs_buf_item_unpin().  Until that happens we will
>> + * keep the buffer locked so that the buffer and buf log item are not reused.
>> + *
>> + * We also set the XFS_BLF_CANCEL flag in the buf log format structure and log
>> + * the buf item.  This will be used at recovery time to determine that copies
>> + * of the buffer in the log before this should not be replayed.
>> + *
>> + * We mark the item descriptor and the transaction dirty so that we'll hold
>> + * the buffer until after the commit.
>> + *
>> + * Since we're invalidating the buffer, we also clear the state about which
>> + * parts of the buffer have been logged.  We also clear the flag indicating
>> + * that this is an inode buffer since the data in the buffer will no longer
>> + * be valid.
>> + *
>> + * We set the stale bit in the buffer as well since we're getting rid of it.
>> + */
>>  void
>>  xfs_trans_binval(
> 
> Does userspace even have half of this functionality? Does marking
> the buffer stale in userspace give the same guarantees as the kernel?
> There's no point bringing across comments that don't reflect how
> userspace works at this point in time...

We have a lot of comments in userspace libxfs/* that reference locking that is 
defined away, etc.  IOWs we have this today, and I thought it was 
understood that shared kernelspace comments didn't always reflect userspace
reality...

*shrug*

Thanks for looking it over,

-Eric


> Cheers,
> 
> Dave.
> 
