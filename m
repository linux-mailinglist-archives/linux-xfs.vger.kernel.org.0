Return-Path: <linux-xfs+bounces-31274-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOlpLrS1nmnwWwQAu9opvQ
	(envelope-from <linux-xfs+bounces-31274-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 09:41:24 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACF0194569
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 09:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07D2C302A7C9
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 08:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513D031CA50;
	Wed, 25 Feb 2026 08:40:55 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from out198-147.us.a.mail.aliyun.com (out198-147.us.a.mail.aliyun.com [47.90.198.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4033115AF
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 08:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008855; cv=none; b=mxQUg5hT4Jv9NvankjQzcrisnKF+GmocmUpYMgsq3ewzcf2px5kXGQGiX0qJWeM3MpcRYezLeTS2EpMq3fi2iChcTgTAyIiYhU8xzmwHPAWGS8hW17m/OO29Q/o/PXkhkLD7oxZSsKHbjyii0CtGMKm4PpbB+CFCavec68f6fNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008855; c=relaxed/simple;
	bh=fdFbJS0aB4CHHkIR6edKcWBecV0Wp4rRnINqW8ekmeg=;
	h=Date:From:To:Subject:Message-Id:MIME-Version:Content-Type; b=gsSHIIOAzJq6tbIYFyf4CW30LQ/IOXdkxklRmM/58jy/+DYKOlqq+jqM1/ooYaxLSEbcOlqkaF4aJ3UfCNdMAVAFR8E9YzbX/RSJ9FJ7lajRzFIMBS8bv6bA5kyuqn5+rgaiBA/vnPrt4Uc1GVEJc3oBNdKtIssYNdEg1kwPeOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.geVJNpR_1772005161 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 15:39:22 +0800
Date: Wed, 25 Feb 2026 15:39:23 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-xfs@vger.kernel.org
Subject: struct xfs_zone_scratch is undefined in 7.0-rc1
Message-Id: <20260225153923.47B2.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.01 [en]
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wangyugui@e16-tech.com,linux-xfs@vger.kernel.org];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31274-lists,linux-xfs=lfdr.de];
	DMARC_NA(0.00)[e16-tech.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 3ACF0194569
X-Rspamd-Action: no action

Hi,

struct xfs_zone_scratch is undefined in 7.0-rc1.

# grep xfs_zone_scratch -nr *
fs/xfs/xfs_zone_gc.c:99:        struct xfs_zone_scratch         *scratch;
#

Could we change 'struct xfs_zone_scratch  *' to 'void *',
or just delete this var?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/02/25



