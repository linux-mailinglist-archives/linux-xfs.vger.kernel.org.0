Return-Path: <linux-xfs+bounces-26407-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57292BD742D
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 06:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD8DC4044E7
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 04:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1817226E702;
	Tue, 14 Oct 2025 04:33:42 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA40EACD;
	Tue, 14 Oct 2025 04:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760416421; cv=none; b=XX+ucVI2IkkDFaMjcMGEl+aUFUaf/xTqrd305XQWfJOQ3bW0ZgW6aGBrljXqP7GWGkG9/yd4HRr+ceQMq9PVBvZRIT6pgtP8LckmuPgtExgXfWVURjrGUrA/uH9nkeeuQPO9HlBgwmmPoWNyyD/1zSffQEN23+v/pLc7hI97ZRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760416421; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LinGbLJbBXR/3Dc/MrhK5sppjij+cLlsxLQjnYa+iQerT5SfVzOOLz4SRHUT7vLSIpxz04uFKEVO4bGGQIEWrWiwfkomtNP8LOUEqxZeD5o2ruEjLvkSsc8DooAhvxnrfHtwjVmGsyZisjyp1akUIAR6BrfN+PbgilU9FTgUhUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D0C1227A87; Tue, 14 Oct 2025 06:33:36 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:33:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3 1/3] common/zoned: add _require_zloop
Message-ID: <20251014043336.GC30741@lst.de>
References: <20251013080759.295348-1-johannes.thumshirn@wdc.com> <20251013080759.295348-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013080759.295348-2-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


