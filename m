Return-Path: <linux-xfs+bounces-31280-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNh2KynEnmkuXQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31280-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:43:05 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 63098195326
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 10:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4B7BC309D27C
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 09:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D615B38F220;
	Wed, 25 Feb 2026 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/UbSjaI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338738F936;
	Wed, 25 Feb 2026 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772012328; cv=none; b=QMLz7YQcdkojm3Nt6dXgzAcSprudmJ/Vai1pfegMmQe23WdkrzxrOYLksJyvb6acODis3d1kycPFGVQVcsLvQ9wVZ1myxpiRv6r5FERnc3J5s27Fxtx/UGcaLtVDT7cLmC/1eG7DDZ0Bk3jRcQZa1nQ18Akw/9zeCGFo+51r3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772012328; c=relaxed/simple;
	bh=dCTE1bcKMGWdjpUZDMsqo3eLezXx0QxE7rEzWAHI8eM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GLlgvIDwbZNmE2gYpEY6R5oxETxQXOTf4crCdNQsD3XTqsb1TlhjN47nH8PBIzicGzWTIKFZdQ6OhMvdJl8rMLbMq2zm+Jp9+kdWlDpWt7DrLRTRIrUem8DwxGSUFYEtynSedPgG3At2JpmVRyMMiNsOqAPLTz+rfTSGp0O9cpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/UbSjaI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569ECC116D0;
	Wed, 25 Feb 2026 09:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772012328;
	bh=dCTE1bcKMGWdjpUZDMsqo3eLezXx0QxE7rEzWAHI8eM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=R/UbSjaIydsVudpYouIylDhErT62WR61MQqifaGGFoaBTnYnAmGGkEnimNQNUO6Zf
	 l9MQcwJT1ZbXyUgVFSLtYg4/t1gpyl/PpS8Z0uQqcGdAybY6cBHYP4qpwrFD0TW7HC
	 2g+YodkSJMdj+Jehf4yI29Uco4g9jE/jIpmVmLgPuOpuhvLP9nxXiGYMgZCWyzZ3p1
	 05YiPoDoUxCieRVs04lxgDG1i09n7JFa8AgnH+lHpUx61IIFtPFY3sNvibfCJExnKI
	 yjz5tJ2HSHf9sml0Yil17E4zfi7/JAP/DXDtAH2Qp0xpN8fX80KyTLhFLfMHb0VEAh
	 KeLO+E/+RYyrQ==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: clm@meta.com, cmaiolino@redhat.com, hch@lst.de, 
 linux-xfs@vger.kernel.org, p.raghav@samsung.com, pankaj.raghav@linux.dev, 
 samsun1006219@gmail.com, stable@vger.kernel.org
In-Reply-To: <177189148163.4009522.17296873599093337410.stg-ugh@frogsfrogsfrogs>
References: <177189148163.4009522.17296873599093337410.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL] xfs: bug fixes for 7.0
Message-Id: <177201232606.40354.7035859505657512309.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 10:38:46 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[meta.com,redhat.com,lst.de,vger.kernel.org,samsung.com,linux.dev,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-31280-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 63098195326
X-Rspamd-Action: no action


On Mon, 23 Feb 2026 16:06:00 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 7.0-rc2.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 4b7b9e3b5abf42756576a2b5d4d31f4c4ae17880

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


