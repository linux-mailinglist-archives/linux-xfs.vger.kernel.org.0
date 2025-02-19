Return-Path: <linux-xfs+bounces-19865-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9541EA3B128
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 06:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79843A717C
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 05:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F149D1B85F8;
	Wed, 19 Feb 2025 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GmC8/FLf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A01AF0DC;
	Wed, 19 Feb 2025 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944612; cv=none; b=Xf7Szv7Q2rvS1s9UDBWl7cXxv54wNUQXtllR10FJeKZo8qcGjwOz+MB7YR8IqByYCfB1pkOn6WmHskn3aP5D824mGA5f4LKlWIclis0sr05AHtOGSD6ImBhL/UBzVnbZzmwwmWPWnEosnlY6y0vC8sVHam35owyYMlV1m7YTvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944612; c=relaxed/simple;
	bh=mdgcNZvzm6rle7WU8fKy60Cyu/5Ee0PHrh3xI9emYek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WF5fjeXdsb5dqdHkzBQgTGnF+UDxb8WCT/WS65mkha9q6s6EU6jBMQMdoHKHtT2BHPoZTeep09r79J2p7sqNNhtHD1n08ZUX4ooDERbGbXnKf2BrhtvwmgX7RNFhObNzhI0q7jrYkVbNK0FKmelX2lVHDAmqC2AS86CvZwJpiwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GmC8/FLf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hNfANHR2JT4Urriln6S9SLByg73Yw1dt7bkl7hjT5Lo=; b=GmC8/FLfqonhRpw7NwXxa5XN6m
	ShOYEiKmyeC3ojlvDwxoxVG62ztwthCJDi7nDJWNXA6Hf2pHrWEtVG44W/YF6Ev4IQoqkrvY8arXI
	69T2nBSaWamfHuS48XUUYu8f2CgIJ/sOhjz0xLaE+VQbiJh8EgnUFfBeTM02QuBixY6BKa2c/EwHj
	uA1crzvm1Y/aAomxHT1ZZd2hUIknTWqcjne8v3E5QM9XUW2AdtxH6YxfjcPRbZjhzK9KEQMxPL/cO
	6ygHzGL5TxV7L0g5asHijYJ0S9JoGz5IvmzXxC3ZWwp+fKgg9sPBGDrCzTeSQplhSVmxyhDhqRjE6
	pdVWtp0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd4l-0000000Ay0x-0gAf;
	Wed, 19 Feb 2025 05:56:51 +0000
Date: Tue, 18 Feb 2025 21:56:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 02/12] misc: rename the dangerous_repair group to
 fuzzers_repair
Message-ID: <Z7Vyo6fmIZ-Efg58@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587440.4078254.13008688687033031883.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587440.4078254.13008688687033031883.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:50:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_repair has been stable for many years now, so I think it's time the
> fuzz tests for it stopped hiding behind the "dangerous" label.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


