Return-Path: <linux-xfs+bounces-27236-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B886C26F3F
	for <lists+linux-xfs@lfdr.de>; Fri, 31 Oct 2025 21:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AD2A24EEE6B
	for <lists+linux-xfs@lfdr.de>; Fri, 31 Oct 2025 20:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27B4329C59;
	Fri, 31 Oct 2025 20:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3hvDimZ4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FBB2FFFAC;
	Fri, 31 Oct 2025 20:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761944074; cv=none; b=c8RF7MHozzij4bwAGAKayBMn0CZ/bWuIZxwM4BSkqRZ3SmqfXkYbfKyGN+eAQYe+3rCm/GdkZbDwenijj97QOuIEC7iNA2Jj9kIPOuVP7jhApZcSOSiX28Sd+J92KTzbWeefYHbuMb+KjNDxIGaa14boCxENtI3+Q3N5+wyQ34I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761944074; c=relaxed/simple;
	bh=XzbD3U2ssINq49YtuphnaJClHSm/ht17xeUcSKx5hP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hB2SDIsIizdetQxqeyTV/xFN/OqWyxhb0yEtx6ZOKDpULWaWVgIrI6/lpzA7sAVdQSjgO54Akmxrz9QlJRycgCJjmi/wXR5iVociLR2ZSmBnNRhF1mGkWddSAK4jR8627j5SJgn6RgZiuF7YSxr6C6WxGp++dsl86Zf447oiVis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3hvDimZ4; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cytWr0jGvzlpkk1;
	Fri, 31 Oct 2025 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761944069; x=1764536070; bh=tdPb1N/XvciTu3RYqzV2sI8G
	GuB9BnyZJXd9jeyzPVI=; b=3hvDimZ4pmAE3kPI9/Qi3OGemeLEeui3ruzROjBn
	E9j0eA8tDDjAZwnY4kN1Q/hbHL+dLF2ZPDd7JH90wIsr8QR5RWjMgFbakqMUQsxL
	YkqMQFVpaFcwIctAh5cmMhyCXTcFjjx9Pv7OZq8TqTQu0iV1lo+OKZD9UFU9lmD4
	CdYhyqYdrHHyVlwsdu+yl48KvBLlv+busO5s2lP3HodQ5Pa/t0FDQEdLK/ngJnf9
	vER4MxP74/j0GFH3Ec3OO2uulmXNtCt4++wY0oJ6U9U32k55BP8w04gmOrYs7f4f
	u7ETNfkeFj1iPjc3ho+MAghTB9qxJVWf0Ir932vxJnEnIw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2Pf8FqZxqiMt; Fri, 31 Oct 2025 20:54:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cytWZ5Cn9zlnfZD;
	Fri, 31 Oct 2025 20:54:17 +0000 (UTC)
Message-ID: <c2734f13-aad7-43a0-a164-b8504ffc1cb4@acm.org>
Date: Fri, 31 Oct 2025 13:54:16 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] block: introduce disk_report_zone()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251031061307.185513-1-dlemoal@kernel.org>
 <20251031061307.185513-5-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251031061307.185513-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/25 11:12 PM, Damien Le Moal wrote:
> -struct disk_report_zones_cb_args {
> -	struct gendisk	*disk;
> -	report_zones_cb	user_cb;
> -	void		*user_data;
> +/*
> + * Zone report arguments for block device drivers report_zones operation.
> + * @cb: report_zones_cb callback for each reported zone.
> + * @data: Private data passed to report_zones_cb.
> + */
> +struct blk_report_zones_args {
> +	report_zones_cb cb;
> +	void		*data;
>   };

The suffix "_args" seems confusing to me because this data structure
includes a callback pointer. Please consider changing "_args" into "_cb"
to make it clear that the data structure includes a callback pointer.
Another data structure that follows this convention is struct
blk_plug_cb:

   struct blk_plug_cb;
   typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
   struct blk_plug_cb {
	struct list_head list;
	blk_plug_cb_fn callback;
	void *data;
   };

Since struct blk_report_zones_args is passed as an argument to
disk_report_zone(), how about renaming this data structure into
struct disk_report_zone_cb?'

Otherwise this patch looks good to me.

Thanks,

Bart.

