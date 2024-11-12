Return-Path: <linux-xfs+bounces-15291-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AFE9C4BAD
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 02:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4682281F4A
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 01:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F3220495B;
	Tue, 12 Nov 2024 01:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NAiG4fYb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5199204921
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374873; cv=none; b=U9anfwdcKaZWqW/wWQTtBSkpopbQm7KH6vqLu1CDqOcbpIlmkGqbS++gQt+2t+5mrObl4EL6S1zDa1TmGm6osodcw7ZByTsn5ZM7/U7X0Bvplg5GGOhmFS8YqR8IOxNcH9GELs6DCwVdIei44chy4fq+btMcq7EGg+vlPFoXFLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374873; c=relaxed/simple;
	bh=qNE4xPLp7nBIFR15eFqlDNdy52LwlFEOEkzBXF7Eo6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jy2fBiKsPp7JxQFcZC4tCUdqDf4P3hhamYZ2ekXXSK2YXRjouUgLBiHS+NLiCVjL50Wpw9lOs3dn7tVC9/kZFKoMQ7vCNGyVg4VroDRFAe+l8Ioqp0d0E6BVhzTj3S8cf4LygZbU8O/iqeGLsJQcskdLN3NeByHGGuIDxp4+9GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NAiG4fYb; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso48483985ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 17:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731374869; x=1731979669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cHu6g4U2gNI2UhKVzoZ4vZcTX3wcbeXZ/77oY66yRA=;
        b=NAiG4fYbvlC35sxhKGRBQoSn5jvB4+SzZnImM2lsz7jIjzkws8eQT4dWgu+G9leRQQ
         cw0N/CZzciPN0Dp7vkps8uD1EOh+q9epOOeELOtsnSq8KiGhlgLTGCh+DNjp2xMwtB1N
         +QBl6gzAWM3hEBIwv/X6HKBCR7gxV2ajssEfx0Yb2X/ojxqXdjdKi0eAJqv468Ybq8QQ
         iN5C5m2uO7EiApLM9u1KCZXw6ccXXDKi+OIIIeJ4WffhQZBoDWDxZ4adP5ybH/HycKxf
         KVDND/KRCYUSjJW5XpYscmtHJ0JGvTBjgi47H5/TCZ2PIl2iSdVezcdB0GqbJQHn1rJC
         t+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731374869; x=1731979669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cHu6g4U2gNI2UhKVzoZ4vZcTX3wcbeXZ/77oY66yRA=;
        b=vfyPwKApxOSu1yUjXNqFaRP4Uwr6TlJXswedRZLvSeTp0Tf38atsPC72oWqtqD6och
         +dZBIJUGWLo0gBO7SSLDs2DnhtLXkH1iED6j6ZqBBsmVD58EslWGrtvRwWeYFI3G/zTi
         FSMqeOuAWyBMDA/K7uw3csE5JLB9ZNWwkos6jyawjP8wMK8tgAX/H+bvmSe2PG1Mc1OL
         YON59Br4FtYg5kS9+duVHAC6AGcLcfpnGzfwZFozLi2JNxC0fK/tEMjH1XlZpYjclxGF
         CsmeJkXX+biix4E2eHiGNNicNYiSxf4aB8fzkH8Pvsy1rX/W24KuwSzCH38S/H4oWATK
         6FeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWoC0Y8yRK0kB2JtxyW6zCALyE8fIvk34/pG4x87cSiW5inNlSoghTTFy4jGrFt+jn99kVCBaX+os=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFR3Ujl2poLbI2Zi1/7MUU2SSv4oQj4QyNjZXCsHzPNdsU+xAi
	vap+Hg4PtVpP5Bt//FJ1FOauLgbHumG2uU3hzIFoK8Qy4xKHtfFyTvRkyGqB81E=
X-Google-Smtp-Source: AGHT+IFU48CTZY2zVB3UqWjxUMV5qEOmyX3/1PolNKUH0Tz1nbYx1CdlmZ4+xf20N9gXyeqo+L/GsA==
X-Received: by 2002:a17:903:1c7:b0:20d:284c:8d54 with SMTP id d9443c01a7336-21183d767d4mr209070405ad.34.1731374868978;
        Mon, 11 Nov 2024 17:27:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e77ad1sm82289335ad.261.2024.11.11.17.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 17:27:48 -0800 (PST)
Message-ID: <0487b852-6e2b-4879-adf1-88ba75bdecc0@kernel.dk>
Date: Mon, 11 Nov 2024 18:27:46 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] mm/filemap: make buffered writes work with
 RWF_UNCACHED
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org,
 clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 kirill@shutemov.name, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20241111234842.2024180-1-axboe@kernel.dk>
 <20241111234842.2024180-11-axboe@kernel.dk>
 <ZzKn4OyHXq5r6eiI@dread.disaster.area>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZzKn4OyHXq5r6eiI@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/24 5:57 PM, Dave Chinner wrote:
> On Mon, Nov 11, 2024 at 04:37:37PM -0700, Jens Axboe wrote:
>> If RWF_UNCACHED is set for a write, mark new folios being written with
>> uncached. This is done by passing in the fact that it's an uncached write
>> through the folio pointer. We can only get there when IOCB_UNCACHED was
>> allowed, which can only happen if the file system opts in. Opting in means
>> they need to check for the LSB in the folio pointer to know if it's an
>> uncached write or not. If it is, then FGP_UNCACHED should be used if
>> creating new folios is necessary.
>>
>> Uncached writes will drop any folios they create upon writeback
>> completion, but leave folios that may exist in that range alone. Since
>> ->write_begin() doesn't currently take any flags, and to avoid needing
>> to change the callback kernel wide, use the foliop being passed in to
>> ->write_begin() to signal if this is an uncached write or not. File
>> systems can then use that to mark newly created folios as uncached.
>>
>> Add a helper, generic_uncached_write(), that generic_file_write_iter()
>> calls upon successful completion of an uncached write.
> 
> This doesn't implement an "uncached" write operation. This
> implements a cache write-through operation.

It's uncached in the sense that the range gets pruned on writeback
completion. For write-through, I'd consider that just the fact that it
gets kicked off once dirtied rather than wait for writeback to get
kicked at some point.

So I'd say write-through is a subset of that.

> We've actually been talking about this for some time as a desirable
> general buffered write trait on fast SSDs. Excessive write-behind
> caching is a real problem in general, especially when doing
> streaming sequential writes to pcie 4 and 5 nvme SSDs that can do
> more than 7GB/s to disk. When the page cache fills up, we see all

Try twice that, 14GB/sec.

> the same problems you are trying to work around in this series
> with "uncached" writes.
> 
> IOWS, what we really want is page cache write-through as an
> automatic feature for buffered writes.

I don't know who "we" is here - what I really want is for the write to
get kicked off, but also reclaimed as part of completion. I don't want
kswapd to do that, as it's inefficient.

>> @@ -70,6 +71,34 @@ static inline int filemap_write_and_wait(struct address_space *mapping)
>>  	return filemap_write_and_wait_range(mapping, 0, LLONG_MAX);
>>  }
>>  
>> +/*
>> + * generic_uncached_write - start uncached writeback
>> + * @iocb: the iocb that was written
>> + * @written: the amount of bytes written
>> + *
>> + * When writeback has been handled by write_iter, this helper should be called
>> + * if the file system supports uncached writes. If %IOCB_UNCACHED is set, it
>> + * will kick off writeback for the specified range.
>> + */
>> +static inline void generic_uncached_write(struct kiocb *iocb, ssize_t written)
>> +{
>> +	if (iocb->ki_flags & IOCB_UNCACHED) {
>> +		struct address_space *mapping = iocb->ki_filp->f_mapping;
>> +
>> +		/* kick off uncached writeback */
>> +		__filemap_fdatawrite_range(mapping, iocb->ki_pos,
>> +					   iocb->ki_pos + written, WB_SYNC_NONE);
>> +	}
>> +}
> 
> Yup, this is basically write-through.

... with pruning once it completes.

>> + * Value passed in to ->write_begin() if IOCB_UNCACHED is set for the write,
>> + * and the ->write_begin() handler on a file system supporting FOP_UNCACHED
>> + * must check for this and pass FGP_UNCACHED for folio creation.
>> + */
>> +#define foliop_uncached			((struct folio *) 0xfee1c001)
>> +#define foliop_is_uncached(foliop)	(*(foliop) == foliop_uncached)
>> +
>>  /**
>>   * filemap_set_wb_err - set a writeback error on an address_space
>>   * @mapping: mapping in which to set writeback error
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 40debe742abe..0d312de4e20c 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -430,6 +430,7 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>>  
>>  	return filemap_fdatawrite_wbc(mapping, &wbc);
>>  }
>> +EXPORT_SYMBOL_GPL(__filemap_fdatawrite_range);
>>  
>>  static inline int __filemap_fdatawrite(struct address_space *mapping,
>>  	int sync_mode)
>> @@ -4076,7 +4077,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>>  	ssize_t written = 0;
>>  
>>  	do {
>> -		struct folio *folio;
>> +		struct folio *folio = NULL;
>>  		size_t offset;		/* Offset into folio */
>>  		size_t bytes;		/* Bytes to write to folio */
>>  		size_t copied;		/* Bytes copied from user */
>> @@ -4104,6 +4105,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>>  			break;
>>  		}
>>  
>> +		/*
>> +		 * If IOCB_UNCACHED is set here, we now the file system
>> +		 * supports it. And hence it'll know to check folip for being
>> +		 * set to this magic value. If so, it's an uncached write.
>> +		 * Whenever ->write_begin() changes prototypes again, this
>> +		 * can go away and just pass iocb or iocb flags.
>> +		 */
>> +		if (iocb->ki_flags & IOCB_UNCACHED)
>> +			folio = foliop_uncached;
>> +
>>  		status = a_ops->write_begin(file, mapping, pos, bytes,
>>  						&folio, &fsdata);
>>  		if (unlikely(status < 0))
>> @@ -4234,8 +4245,10 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>  		ret = __generic_file_write_iter(iocb, from);
>>  	inode_unlock(inode);
>>  
>> -	if (ret > 0)
>> +	if (ret > 0) {
>> +		generic_uncached_write(iocb, ret);
>>  		ret = generic_write_sync(iocb, ret);
> 
> Why isn't the writethrough check inside generic_write_sync()?
> Having to add it to every filesystem that supports write-through is
> unwieldy. If the IO is DSYNC or SYNC, we're going to run WB_SYNC_ALL
> writeback through the generic_write_sync() path already, so the only time we
> actually want to run WB_SYNC_NONE write-through here is if the iocb
> is not marked as dsync.
> 
> Hence I think this write-through check should be done conditionally
> inside generic_write_sync(), not in addition to the writeback
> generic_write_sync() might need to do...

True good point, I'll move it to generic_write_sync() instead, it needs
to go there for all three spots where it's added anyway.

> That also gives us a common place for adding cache write-through
> trigger logic (think writebehind trigger logic similar to readahead)
> and this is also a place where we could automatically tag mapping
> ranges for reclaim on writeback completion....

I appreciate that you seemingly like the concept, but not that you are
also seemingly trying to commandeer this to be something else. Unless
you like the automatic reclaiming as well, it's not clear to me.

I'm certainly open to doing the reclaim differently, and I originally
wanted to do tagging for that - but there are no more tags available.
Yes we could add that, but then the question was whether that was
worthwhile. Hence I just went with a folio flag instead.

But the mechanism for doing that doesn't interest me as much as the
concept of it. Certainly open to ideas on that end.

-- 
Jens Axboe

