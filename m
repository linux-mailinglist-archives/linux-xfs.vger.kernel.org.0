Return-Path: <linux-xfs+bounces-30057-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPN0AjjGcGkNZwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30057-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:27:36 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA4D56C03
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E97145263C7
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB033D5256;
	Wed, 21 Jan 2026 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ddgk5e1z"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F2547A0B8
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998278; cv=none; b=NmwvBgOCMI/5F3sLt29TIyu602A/8VO/d3rUCntfhQi4+/AaY+oNb6uXV5MlFahKly7Z7MVGRAwnUqDxYK8NY+U51m1pGWELIE+eL7N4ch3XK/0Q+SUonHLIbPeEPQB7T7R7HD4jBB1cSOOc9tRuQhZ9p4kFZLQOA6FQX5e2uqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998278; c=relaxed/simple;
	bh=r5uXBN1RR1MqKw90zbh/qk8HfMtKAsxi3VQjAyYW/O8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DV1vXeJc1/X6wyBhD+mRfzQEF5wnQcXSE/VU12ydFG3LYsDX5KxO5fhAl/CgDtr3EcJvmdjPU/Dm6YOhvqGWqAHL74kAK3YPH8ftv5RxkiY3RlSi20EfHngRIvH8Sp78f4freUZA9ZzSCg6cBZNoLF2X/94hLzs71abkwj5bwQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ddgk5e1z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10E5C19421;
	Wed, 21 Jan 2026 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998277;
	bh=r5uXBN1RR1MqKw90zbh/qk8HfMtKAsxi3VQjAyYW/O8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Ddgk5e1zmPukPiTd9uk+dWjgbTVNEUhfxjTr8gA1L5kRv6j6NZgzD2LF++lRGCMER
	 5s4OgP8DPfQyrkCUirnUYABTHmRfI+6j5zSWAO51LwEvS6Z5kklU3Q248QJ04asTE3
	 3cL0JZp4yjSkZzHs/BDodPZ4MUWWHHSJaqCAzWZMqZRFC5ld9H2pIHqse4dpKkcS++
	 ALvYsgzf/T6/fKrBKCcpmEA2JOHO7hRKejwVuxrD8k3R57+1p0P1lC9aWdUU8TRmwh
	 UTDahGMhwL5sZDBnJJZbg+/NLTfIFWN5NqBrrPEKIQC4X5SM6q0uMVyHGFq7q/5qcl
	 XXNI3S7TI7zjQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Wenwu Hou <hwenwur@gmail.com>
Cc: dchinner@redhat.com, hch@infradead.org
In-Reply-To: <20260117065243.42955-1-hwenwur@gmail.com>
References: <20260117065243.42955-1-hwenwur@gmail.com>
Subject: Re: [PATCH v2] xfs: fix incorrect context handling in
 xfs_trans_roll
Message-Id: <176899827656.852996.1233374659507555082.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:24:36 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30057-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: CFA4D56C03
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, 17 Jan 2026 14:52:43 +0800, Wenwu Hou wrote:
> The memalloc_nofs_save() and memalloc_nofs_restore() calls are
> incorrectly paired in xfs_trans_roll.
> 
> Call path:
> xfs_trans_alloc()
>     __xfs_trans_alloc()
> 	// tp->t_pflags = memalloc_nofs_save();
> 	xfs_trans_set_context()
> ...
> xfs_defer_trans_roll()
>     xfs_trans_roll()
>         xfs_trans_dup()
>             // old_tp->t_pflags = 0;
>             xfs_trans_switch_context()
>         __xfs_trans_commit()
>             xfs_trans_free()
>                 // memalloc_nofs_restore(tp->t_pflags);
>                 xfs_trans_clear_context()
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix incorrect context handling in xfs_trans_roll
      commit: a1ca658d649a4d8972e2e21ac2625b633217e327

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


