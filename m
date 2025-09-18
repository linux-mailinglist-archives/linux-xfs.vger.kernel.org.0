Return-Path: <linux-xfs+bounces-24564-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6E4B21FC8
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Aug 2025 09:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99544506492
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Aug 2025 07:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11182DEA7E;
	Tue, 12 Aug 2025 07:44:21 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA52D8375;
	Tue, 12 Aug 2025 07:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984661; cv=none; b=EELpk8fswA4AOzRLBK3RYLC+H+zk1p4B8A2aY2+e4uawnox2Lor6YRdlgoYzAwtQghhu5gBDbT+04m0J4EW6fBw45OQpGy05ccdcZQf0pLy1Kp/y0YfAMgA8U7UNNN7UvVYcijZ8sItEJ/NDWO+WdUT3kulvE7iz8y7Le/F9VGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984661; c=relaxed/simple;
	bh=EOnGf5A0r9WqcQ9tnVmSaq/bK7rmh2qYIHr/mwirnEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4DARirw61+KV6i4u8JkYam6UU0pRIrkG0Slf5020kqz2k0rnMuXlRFwInsWaf9BJ6kiUGvFcFtnJ88cd3oC7VoUWZzaa8c0SjrggmrfOZeLrum40eoMQyZ9ior2Yeoo83w8XKUDPbhU9iuCPNtQ3DQ9m1AxzK9/7XCcyN+tSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A539868AA6; Tue, 12 Aug 2025 09:44:16 +0200 (CEST)
Date: Tue, 12 Aug 2025 09:44:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, djwong@kernel.org, ebiggers@kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 14/29] xfs: add attribute type for fs-verity
Message-ID: <20250812074415.GD18413@lst.de>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org> <20250728-fsverity-v1-14-9e5443af0e34@kernel.org> <20250811115023.GD8969@lst.de> <je3ryqpl3dyryplaxt6a5h6vtvsa2tpemfzraofultyfccr4a4@mftein7jfwmt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <je3ryqpl3dyryplaxt6a5h6vtvsa2tpemfzraofultyfccr4a4@mftein7jfwmt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 11, 2025 at 09:00:29PM +0200, Andrey Albershteyn wrote:
> Mostly because it was already implemented. But looking for benefits,
> attr can be inode LOCAL so a bit of saved space? Also, seems like a
> better interface than to look at a magic offset

Well, can you document the rationale somewhere?


