Return-Path: <linux-xfs+bounces-31507-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNZ2CaaPpWmoDgYAu9opvQ
	(envelope-from <linux-xfs+bounces-31507-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 02 Mar 2026 14:24:54 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD411D9B2B
	for <lists+linux-xfs@lfdr.de>; Mon, 02 Mar 2026 14:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DA34D301BAB6
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Mar 2026 13:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BFD3E7151;
	Mon,  2 Mar 2026 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LueOPztv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BCC248F57
	for <linux-xfs@vger.kernel.org>; Mon,  2 Mar 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457855; cv=none; b=retn8pZVxzAtCys8QXZ40oUgXTHUQQJPHVdy71bg+LraKdVXxiBgKINWWn9NWk0miuVvXWwI5urCJX1yFvTeuOJ3QG3jgxHTy6zJBYWyTabTxIw+M8mQ4Onj4BR8pqYmlzIntVIxSvtHCbjsR0UGC0609qvdoQFoIQTtzp7o8jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457855; c=relaxed/simple;
	bh=ltfsj99I78ai3Uw4cmgHT0d1UXB8XXPY1S98SmQRKs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gOhtdXm1NmcMicIuY1yex/MDLlI4JqzAeLPQODT6IulEspZ5fWsixFQDXAtm5tUsleDke1roaV0UdufrOQISlK71DQScy4lHLs5I+RKont1ZmuXdq/pTQEyv5hLMMaZ9zEKbIPQx6cQkYOKDEwihwiOWSwAxYwfVqorR45W35Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LueOPztv; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8274a3db5e3so1921793b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2026 05:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772457849; x=1773062649; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v9ZnDEvgwTfM42XxCeWf1ZWhMQzzUDLYvt9awp7GUwc=;
        b=LueOPztvjLS8TwLVZEA7S/Gqx4FUAvlFDty0m5Ywooe7fOv98qYJW5jZgNLf+dBVXL
         LDHJBQaDuMOVCpSXyW1+Ifxtrxx1k5aBtNnH2bops36EEp5mcPiOPW1dijZj1Czhbdp/
         pZsaRzkSCMd1BdzxeRCthPqHRcn1DA6jZyy40+TlkrDM7menZPM6nH5P6RmWYEn14G4q
         mjcww6g4kmG1tdsC21C6nJlZYWHEXqKLEHd/cI70mBkKIt6yI8nFQYdhYyvAi4oj8qQH
         SKzV6RYep9VvN8RxJ5zmEyG44P3uYDiHRi8gHza32G3OS+HmEVQiquxEOGUwSF3IT4nI
         HL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457849; x=1773062649;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v9ZnDEvgwTfM42XxCeWf1ZWhMQzzUDLYvt9awp7GUwc=;
        b=dT9+0hH2X9GnMMTt7BvJJM8zsfmC9i42lmvtYJxMtmLPhxLFxUM7SzASB1GpcgBeFg
         vudJqTegCGWCkXP4pQLAAWJyePI543XG/XGhqrgUzfLzMDzUG4F+aoZmME44dvLWQDXf
         5369XCU4CEWvvc7WPEY2xRgDeVcCA/aXH/E+5+yR0Vkh73xGvgJLsFTPfh0pNTNGngko
         koW00DItuqHdju3FQpAEph0Ly1tz9w+wYxFYVa3BN4W40uaWLuq+1Q66MCnbYMvt3yRo
         yuaz7wpr6s3o2UkQ5kdGxaHpC2y3+J8OIuXkWmvbMyOteCQ4Q31v89B2T3Ddc3Fp9QXE
         s35Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmKhwBNoGYcVDDmnPRS7lxWua7rgGxZXtciYJgd4GWxADzeLW5yoWwRp+1X4is40U7jxmhmM9zXiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOojk9NqAHblsp5eQnIbRKdi2sEfZ4AHsnUImVuoZc+1iNxQT4
	J0ATa8hMVFGKcQ3+1ZMFeevj6gTsxDc8ZXPneUUA/C6Fj7YH/n8suy7f
X-Gm-Gg: ATEYQzwncz8YXNegYTyQ5tuF+i4VGhXNBm/qdFLdg5fb99n0WXBOyCPb0ubSQ1roeq4
	fK8yGcfi5SrhVqbno6O7WXMAAdnU0sRtb6NDiwHHOjTROuCRiuQ882J9X5j56AtkO6GgNN+grec
	Iw5XetZdu1HoPZ7bP8LaL05robVnKW9clrgGLL4QQUaHSA6kywRGN0WlqZVYSz49FWk2tPCGGsS
	7lJELV/UmrMmMCtdw0mE3y7mQFEf4ntEQ5qZCDoTYW9jtsELJpfRmlM4B8zroUFIo4aq/CWWpYY
	qfvXO8cxo+0UvespzAibEAM5GM3ZuN8vs1irZqKQ+p1DX5Hfqe23zEcKj8amV1CdNvlVExoxMrb
	JkiyAv+b2ZQiQrDSXrITmg3wX7AulkSYKQbsaZHXYqgiux2cehCtxs260nEE7Pnl+aDk7UGgHQN
	Fg2y2cY5SHf9LLEFKXWjGMprMPZBg=
X-Received: by 2002:a05:6a00:3a25:b0:827:2891:c177 with SMTP id d2e1a72fcca58-8274da2fee7mr8658465b3a.64.1772457848572;
        Mon, 02 Mar 2026 05:24:08 -0800 (PST)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a05e831sm13446967b3a.58.2026.03.02.05.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 05:24:08 -0800 (PST)
Message-ID: <73e51635-e461-4292-a858-f73ea4d23545@gmail.com>
Date: Mon, 2 Mar 2026 21:24:05 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] fstests: add test for inotify isolation on cloned
 devices
To: Amir Goldstein <amir73il@gmail.com>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <cover.1772095513.git.asj@kernel.org>
 <78014ba3d564004081dca3c1d7e69cec8943f629.1772095513.git.asj@kernel.org>
 <aaQ59uL3rG7_WYHJ@amir-ThinkPad-T480>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aaQ59uL3rG7_WYHJ@amir-ThinkPad-T480>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31507-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anajainsg@gmail.com,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDD411D9B2B
X-Rspamd-Action: no action


>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -r -f $tmp.*
>> +	umount $mnt1 $mnt2 2>/dev/null
>> +	_scratch_dev_pool_put
>> +}
>> +
>> +_scratch_dev_pool_get 2
>> +_scratch_mkfs_sized_clone >$seqres.full 2>&1
>> +devs=($SCRATCH_DEV_POOL)
>> +mnt2=$TEST_DIR/mnt2
>> +mkdir -p $mnt2
>> +
>> +_scratch_mount $(_clone_mount_option)
>> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
>> +						_fail "Failed to mount dev2"
>> +
>> +log1=$tmp.inotify1
>> +log2=$tmp.inotify2
>> +
>> +echo "Setup inotify watchers on both SCRATCH_MNT and mnt2"
>> +$INOTIFYWAIT_PROG -m -e create --format '%f' $SCRATCH_MNT > $log1 2>&1 &
>> +pid1=$!
>> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
>> +pid2=$!
>> +sleep 2
>> +
>> +echo "Trigger file creation on SCRATCH_MNT"
>> +touch $SCRATCH_MNT/file_on_scratch_mnt
>> +sync
>> +sleep 1
>> +
>> +echo "Trigger file creation on mnt2"
>> +touch $mnt2/file_on_mnt2
>> +sync
>> +sleep 1
>> +
>> +echo "Verify inotify isolation"
>> +kill $pid1 $pid2
>> +wait $pid1 $pid2 2>/dev/null
> 
> I think you also need to take care of killing the bg process
> in _cleanup() so that the test could be cleanly aborted.

You are right, SIGINT can terminate the testcase at any point, we need
kill(1) in _cleanup().

I'll fix this in v2.

Thanks, Anand



